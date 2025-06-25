module AresMUSH
  module Manage
    class DestroyConfirmCmd
      include CommandHandler
      
      def handle
        target_id = client.program[:destroy_target]
        target_class = client.program[:destroy_class]
        
        if (!target_id)
          client.emit_failure t('manage.no_destroy_in_progress')
          return
        end
        
        results = ClassTargetFinder.find("#{target_id}", target_class, enactor)
        if (!results.found?)
          client.emit_failure results.error
          return
        end
       
        target = results.target
       
        if (!Manage.can_manage_object?(enactor, target))
          client.emit_failure t('dispatcher.not_allowed')
          return
        end
        
        if (target.class == Room)          
          if (target.scene)
            client.emit_failure t('manage.cannot_destroy_room_with_scene')
            return
          end          
        end
        
        if (target.class == Character)
          if (Login.is_online?(target))
            client.emit_failure t('manage.cannot_destroy_online')
            return
          end
          
          if (FS3Combat.is_in_combat?(target.name))
            client.emit_failure t('manage.cannot_destroy_in_combat')
            return
          end
        end
        
        target.delete
        client.emit_success t('manage.object_destroyed', :name => target.name)
        client.program.delete(:destroy_target)
      end
    end
  end
end

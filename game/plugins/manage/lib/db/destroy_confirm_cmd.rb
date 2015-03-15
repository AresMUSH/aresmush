module AresMUSH
  module Manage
    class DestroyConfirmCmd
      include Plugin
      include PluginWithoutArgs
      include PluginRequiresLogin
      
      def want_command?(client, cmd)
        cmd.root_is?("destroy") && cmd.switch_is?("confirm")
      end

      def handle
        target_id = client.program[:destroy_target]
        
        if (target_id.nil?)
          client.emit_failure t('manage.no_destroy_in_progress')
          return
        end
        
        find_result = AnyTargetFinder.find("#{target_id}", client)
        
        if (!find_result.found?)
          client.emit_failure(find_result.error)
          return
        end
        
        target = find_result.target
        if (!Manage.can_manage_object?(client.char, target))
          client.emit_failure t('dispatcher.not_allowed')
          return
        end
        
        if (target.class == Character)
          if (target.is_online?)
            client.emit_failure t('manage.cannot_destroy_online')
            return
          end
        end
        
        if (target.class == Room)
          target.characters.each do |c|
            connected_client = c.client
            if (!connected_client.nil?)
              connected_client.emit_ooc t('manage.room_being_destroyed')
            end
            Rooms.move_to(connected_client, c, Game.master.welcome_room)
          end
        end
        target.destroy
        client.emit_success t('manage.object_destroyed', :name => target.name)
        client.program.delete(:destroy_target)
      end
    end
  end
end

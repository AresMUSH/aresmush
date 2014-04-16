module AresMUSH
  module Manage
    class DestroyConfirmCmd
      include Plugin
      include PluginWithoutArgs
      include PluginRequiresLogin
      
      def want_command?(client, cmd)
        cmd.root_is?("destroy") && cmd.switch_is?("confirm")
      end

      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage?(client.char)
        return nil
      end

      def handle
        target = client.program[:destroy_target]
        
        if (target.nil?)
          client.emit_failure t('manage.no_destroy_in_progress')
          return
        end
        
        if (target.class == Character)
          connected_client = Global.client_monitor.find_client(target)
          if (!connected_client.nil?)
            client.emit_failure t('manage.cannot_destroy_online')
            return
          end
        end
        
        if (target.class == Room)
          target.characters.each do |c|
            connected_client = Global.client_monitor.find_client(c)
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

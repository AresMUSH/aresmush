module AresMUSH
  module Utils
    class DestroyCmd
      include Plugin
      include PluginRequiresArgs
      
      attr_accessor :target
            
      def initialize
        self.required_args = ['target']
        self.help_topic = 'destroy'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("destroy")
      end
      
      def crack!
        self.target = trim_input(cmd.args)
      end

      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage?(client.char)
        return nil
      end

      def handle
        find_result = VisibleTargetFinder.find(self.target, client)
        
        if (!find_result.found?)
          find_result = AnyTargetFinder.find(self.target, client)
        end
        
        if (!find_result.found?)
          client.emit_failure(find_result.error)
          return
        end
        target = find_result.target
        
        if (target.class == Character)
          connected_client = Global.client_monitor.find_client(target)
          if (!connected_client.nil?)
            client.emit_failure(t('manage.cannot_destroy_online'))
            return
          end
        end
        
        if (target == Game.master.welcome_room || target == Game.master.ic_start_room ||
          target == Game.master.idle_room)
          client.emit_failure(t('manage.cannot_destroy_special_rooms'))
          return
        end
        
        if (!cmd.switch_is?('confirm'))
          client.emit(t('manage.confirm_object_destroy', :id => target.id, :name => target.name, :type => target.class.name.rest("::"), :examine => target.to_json))
          return
        end

        if (target.class == Room)
          target.characters.each do |c|
            connected_client = Global.client_monitor.find_client(c)
            if (!connected_client.nil?)
              connected_client.emit_ooc t('manage.room_being_destroyed')
              Rooms.move_to(connected_client, c, Game.master.welcome_room)
            end
          end
        end
        target.destroy
        client.emit_success t('manage.object_destroyed', :name => target.name)
      end
    end
  end
end

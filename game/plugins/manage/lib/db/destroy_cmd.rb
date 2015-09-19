module AresMUSH
  module Manage
    class DestroyCmd
      include Plugin
      include PluginRequiresArgs
      include PluginRequiresLogin
      
      attr_accessor :name
            
      def initialize
        self.required_args = ['name']
        self.help_topic = 'destroy'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("destroy") && cmd.switch.nil?
      end
      
      def crack!
        self.name = trim_input(cmd.args)
      end

      def handle
        find_result = AnyTargetFinder.find(self.name, client)
        
        if (!find_result.found?)
          client.emit_failure(find_result.error)
          return
        end
        
        target = find_result.target

        if (!Manage.can_manage_object?(client.char, target))
          client.emit_failure t('dispatcher.not_allowed')
          return
        end
        
        if (Game.master.is_special_room?(target))
          client.emit_failure(t('manage.cannot_destroy_special_rooms'))
          return
        end
        
        if (Game.master.is_special_char?(target))
          client.emit_failure(t('manage.cannot_destroy_special_chars'))
          return
        end
        
        client.program = { :destroy_target => target.id }
        client.emit BorderedDisplay.text(t('manage.confirm_object_destroy', :name => target.name, :type => target.class.name.rest("::"), :examine => target.to_json))
      end
    end
  end
end

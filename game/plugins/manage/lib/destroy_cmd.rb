module AresMUSH
  module Manage
    class DestroyCmd
      include Plugin
      include PluginRequiresArgs
      include PluginRequiresLogin
      
      attr_accessor :target
            
      def initialize
        self.required_args = ['target']
        self.help_topic = 'destroy'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("destroy") && cmd.switch.nil?
      end
      
      def crack!
        self.target = trim_input(cmd.args)
      end

      def check_can_manage
        return t('dispatcher.not_allowed') if !Manage.can_manage?(client.char)
        return nil
      end

      def handle
        find_result = AnyTargetFinder.find(self.target, client)
        
        if (!find_result.found?)
          client.emit_failure(find_result.error)
          return
        end
        
        target = find_result.target
        
        if (Game.master.is_special_room?(target))
          client.emit_failure(t('manage.cannot_destroy_special_rooms'))
          return
        end
        
        client.program = { :destroy_target => target }
        client.emit t('manage.confirm_object_destroy', :name => target.name, :type => target.class.name.rest("::"), :examine => target.to_json)
      end
    end
  end
end

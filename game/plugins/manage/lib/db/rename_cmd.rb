module AresMUSH
  module Manage
    class RenameCmd
      include Plugin
      include PluginWithoutSwitches
      include PluginRequiresArgs
      include PluginRequiresLogin
      
      attr_accessor :target
      attr_accessor :name
            
      def initialize
        self.required_args = ['target']
        self.required_args = ['name']
        self.help_topic = 'rename'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("rename")
      end
      
      def crack!
        cmd.crack!(CommonCracks.arg1_equals_arg2)
        self.target = trim_input(cmd.args.arg1)
        self.name = trim_input(cmd.args.arg2)
      end

      def handle
        find_result = AnyTargetFinder.find(self.target, client)
        
        if (!find_result.found?)
          client.emit_failure(find_result.error)
          return
        end
        target = find_result.target

        if (!Manage.can_manage_object?(client.char, target))
          client.emit_failure t('dispatcher.not_allowed')
          return
        end
        
        name_validation_msg = target.class.check_name(self.name)
        if (!name_validation_msg.nil?)
          client.emit_failure(name_validation_msg)
          return
        end
        
        if (target.class == Exit)
          if (target.source.has_exit?(self.name))
            client.emit_failure(t('manage.exit_already_exists'))
            return
          end
        end
        
        old_name = target.name
        target.name = self.name
        target.save!
        client.emit_success t('manage.object_renamed', :type => target.class.name.rest("::"), :old_name => old_name, :new_name => self.name)
      end
    end
  end
end

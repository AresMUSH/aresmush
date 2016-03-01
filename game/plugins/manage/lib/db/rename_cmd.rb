module AresMUSH
  module Manage
    class RenameCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresArgs
      include CommandRequiresLogin
      
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
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.target = trim_input(cmd.args.arg1)
        self.name = trim_input(cmd.args.arg2)
      end

      def handle
        AnyTargetFinder.with_any_name_or_id(self.target, client) do |model|
          if (!Manage.can_manage_object?(client.char, model))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
        
          name_validation_msg = model.class.check_name(self.name)
          if (!name_validation_msg.nil?)
            client.emit_failure(name_validation_msg)
            return
          end
        
          if (model.class == Exit)
            existing_exit = model.source.get_exit(self.name)
            if (existing_exit && existing_exit != model)
              client.emit_failure(t('manage.exit_already_exists'))
              return
            end
          end
        
          if (model.class == Character)
            if (model.linked_characters.keys.count > 0)
              client.emit_failure(t('manage.cant_rename_handle_with_links'))
              return
            end
          end
        
          old_name = model.name
          model.name = self.name
          model.save!
          client.emit_success t('manage.object_renamed', :type => model.class.name.rest("::"), :old_name => old_name, :new_name => self.name)
        end
      end
    end
  end
end

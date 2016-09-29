module AresMUSH
  module Manage
    class RenameCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresArgs
      include CommandRequiresLogin
      
      attr_accessor :target
      attr_accessor :name
            
      def initialize(client, cmd, enactor)
        self.required_args = ['target']
        self.required_args = ['name']
        self.help_topic = 'rename'
        super
      end
      
      def crack!
        cmd.crack_args!(CommonCracks.arg1_equals_arg2)
        self.target = trim_input(cmd.args.arg1)
        self.name = trim_input(cmd.args.arg2)
      end

      def handle
        AnyTargetFinder.with_any_name_or_id(self.target, client) do |model|
          if (!can_rename_self(model) && !Manage.can_manage_object?(enactor, model))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
        
          name_validation_msg = model.class.check_name(self.name)
          if (name_validation_msg)
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
        
          old_name = model.name
          model.name = self.name
          model.save!
          client.emit_success t('manage.object_renamed', :type => model.class.name.rest("::"), :old_name => old_name, :new_name => self.name)
        end
      end
      
      def can_rename_self(model)
        return true if (model == enactor && !model.is_approved?)
        false          
      end
    end
  end
end

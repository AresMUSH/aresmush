module AresMUSH
  module Manage
    class RenameCmd
      include CommandHandler
      
      attr_accessor :target
      attr_accessor :name

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target = trim_arg(args.arg1)
        self.name = trim_arg(args.arg2)
      end
      
      def required_args
        [ self.target, self.name ]
      end
      
      def handle
        AnyTargetFinder.with_any_name_or_id(self.target, client, enactor) do |model|
          if (!can_rename_self(model) && !Manage.can_manage_object?(enactor, model))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
        
          if (model.class == Character)
            taken_error = Login.name_taken?(name, model)
            if (taken_error)
              client.emit_failure taken_error
              return
            end
            name_validation_msg = model.class.check_name(self.name)
          else
            name_validation_msg = model.class.check_name(self.name)
          end
          
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
          model.update(name: self.name)
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

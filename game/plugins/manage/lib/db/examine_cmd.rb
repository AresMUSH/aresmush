module AresMUSH
  module Manage
    class ExamineCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresArgs
      include CommandRequiresLogin
      
      attr_accessor :target
      
      def crack!
        self.target = trim_input(cmd.args)
      end
      
      def required_args
        {
          args: [ self.target ],
          help: 'examine'
        }
      end
      
      def handle
        AnyTargetFinder.with_any_name_or_id(self.target, client, enactor) do |model|

          if (!Manage.can_manage_object?(enactor, model))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end

          line = "-".repeat(78)
          json = model.print_json
          
          client.emit_raw "#{line}\n#{json}#{}\n#{line}"
        end
      end
      
      def print_model
      end
    end
  end
end

module AresMUSH
  module Manage
    class ExamineCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresArgs
      include CommandRequiresLogin
      include TemplateFormatters
      
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

          client.emit_raw "#{line}\n#{model.to_json}\n#{line}\n"
        end
      end
    end
  end
end

module AresMUSH
  module Manage
    class ExamineCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresArgs
      include CommandRequiresLogin
      include TemplateFormatters
      
      attr_accessor :target
      
      def initialize(client, cmd, enactor)
        self.required_args = ['target']
        self.help_topic = 'examine'
        super
      end
      
      def crack!
        self.target = trim_input(cmd.args)
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

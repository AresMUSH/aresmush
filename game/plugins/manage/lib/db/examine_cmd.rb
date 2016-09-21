module AresMUSH
  module Manage
    class ExamineCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresArgs
      include CommandRequiresLogin
      include TemplateFormatters
      
      attr_accessor :target
      
      def initialize
        self.required_args = ['target']
        self.help_topic = 'examine'
        super
      end
      
      def crack!
        self.target = trim_input(cmd.args)
      end

      def handle
        AnyTargetFinder.with_any_name_or_id(self.target, client) do |model|

          if (!Manage.can_manage_object?(client.char, model))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end

          client.emit_raw "#{line}\n#{model.to_json}\n#{line}\n"
        end
      end
    end
  end
end

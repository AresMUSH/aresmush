module AresMUSH
  module Chargen
    class AppRejectCmd
      include CommandHandler
      
      attr_accessor :name, :message
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = trim_arg(args.arg1)
        self.message = args.arg2
      end
      
      def required_args
        [ self.name, self.message ]
      end

      def check_permission
        return t('dispatcher.not_allowed') if !Chargen.can_approve?(enactor)
        return nil
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          error = Chargen.reject_char(enactor, model, self.message)
          if (error)
            client.emit_failure error
          else
            client.emit_success t('chargen.app_rejected', :name => model.name)
          end
        end
      end
    end
  end
end
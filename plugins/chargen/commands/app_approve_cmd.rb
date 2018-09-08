module AresMUSH
  module Chargen
    class AppApproveCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = trim_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
      end
      
      def check_permission
        return t('dispatcher.not_allowed') if !Chargen.can_approve?(enactor)
        return nil
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          error = Chargen.approve_char(enactor, model, '')
          if (error)
            client.emit_failure error
          else
            client.emit_success t('chargen.app_approved', :name => model.name)
          end
        end
      end
    end
  end
end
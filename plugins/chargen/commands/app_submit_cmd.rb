module AresMUSH
  module Chargen
    class AppSubmitCmd
      include CommandHandler
      
      attr_accessor :app_notes
      
      def parse_args
        self.app_notes = cmd.args
      end
      
      def check_approval
        return t('chargen.you_are_already_approved') if enactor.is_approved?
        return nil
      end
      
      def handle
        if (cmd.switch_is?("confirm"))
          client.emit_success Chargen.submit_app(enactor, client.program[:app_notes])
          client.emit_ooc t('chargen.approval_reminder')
        else
          client.program[:app_notes] = self.app_notes
          client.emit_ooc t('chargen.app_confirm')
        end
      end
    end
  end
end
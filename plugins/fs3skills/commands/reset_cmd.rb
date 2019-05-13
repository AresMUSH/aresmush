module AresMUSH

  module FS3Skills
    class ResetCmd
      include CommandHandler

      def check_chargen_locked
        Chargen.check_chargen_locked(enactor)
      end

      def handle
        FS3Skills.reset_char(enactor)        
        client.emit_success t('fs3skills.reset_complete')
      end
    end
  end
end

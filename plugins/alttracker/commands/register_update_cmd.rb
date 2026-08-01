module AresMUSH
  module AltTracker
    class RegisterUpdateCmd
      include CommandHandler

      attr_accessor :new_value, :code_word

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.new_value  = trim_arg(args.arg1)
        self.code_word  = trim_arg(args.arg2)
      end

      def check_args
        return t('alttracker.value_required') if self.new_value.blank?
        return t('alttracker.code_word_required') if self.code_word.blank?
        return nil
      end

      def check_registered
        return t('alttracker.not_registered') if !enactor.alt_tracker
        return nil
      end

      def handle
        result = AltTracker.update_tracker(enactor, self.new_value, self.code_word)

        if !result
          client.emit_failure t('alttracker.update_failed')
          return
        end

        case result[:changed]
        when :email
          client.emit_success t('alttracker.email_updated', :email => result[:value])
        when :code_word
          client.emit_success t('alttracker.code_word_updated', :code_word => result[:value])
        end
      end
    end
  end
end

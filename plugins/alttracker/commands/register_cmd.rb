module AresMUSH
  module AltTracker
    class RegisterCmd
      include CommandHandler

      attr_accessor :email, :code_word

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.email = trim_arg(args.arg1)
        self.code_word = trim_arg(args.arg2)
      end

      def check_email
        return t('alttracker.invalid_email') if !AltTracker.valid_email?(self.email)
        return nil
      end

      def check_code_word
        return t('alttracker.code_word_required') if self.code_word.blank?
        return nil
      end

      def check_already_registered
        return t('alttracker.already_registered') if enactor.alt_tracker
        return nil
      end

      def handle
        tracker = AltTracker.find_or_create_and_link(enactor, self.email, self.code_word)

        if tracker
          client.emit_success t('alttracker.register_success')
        else
          client.emit_failure t('alttracker.register_failed')
        end
      end
    end
  end
end

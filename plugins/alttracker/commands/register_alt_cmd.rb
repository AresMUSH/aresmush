module AresMUSH
  module AltTracker
    class RegisterAltCmd
      include CommandHandler

      attr_accessor :target_name, :code_word

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target_name = titlecase_arg(args.arg1)
        self.code_word   = trim_arg(args.arg2)
      end

      def check_args
        return t('alttracker.alt_name_required') if self.target_name.blank?
        return t('alttracker.code_word_required') if self.code_word.blank?
        return nil
      end

      def check_already_registered
        return t('alttracker.already_registered') if enactor.alt_tracker
        return nil
      end

      def handle
        other_char = Character.find_one_by_name(self.target_name)

        if !other_char
          client.emit_failure t('alttracker.character_not_found')
          return
        end

        tracker = AltTracker.link_to_existing_alt(enactor, other_char, self.code_word)

        if tracker
          client.emit_success t('alttracker.register_alt_success', :name => other_char.name)
        else
          client.emit_failure t('alttracker.register_alt_failed')
        end
      end
    end
  end
end

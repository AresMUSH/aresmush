module AresMUSH
  module AltTracker
    class RegisterWordCmd
      include CommandHandler

      attr_accessor :target_name, :new_code_word

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target_name   = titlecase_arg(args.arg1)
        self.new_code_word = trim_arg(args.arg2)
      end

      def check_staff
        return t('dispatcher.not_allowed') unless enactor.has_role?("admin") || enactor.has_role?("staff")
        return nil
      end

      def check_args
        return t('alttracker.character_required') if self.target_name.blank?
        return t('alttracker.code_word_required') if self.new_code_word.blank?
        return nil
      end

      def handle
        char = Character.find_one_by_name(self.target_name)

        if !char
          client.emit_failure t('alttracker.character_not_found')
          return
        end

        if !char.alt_tracker
          client.emit_failure t('alttracker.target_not_registered', :name => char.name)
          return
        end

        tracker = AltTracker.staff_reset_code_word(char, self.new_code_word, enactor)

        if tracker
          client.emit_success t('alttracker.staff_code_word_reset',
                                :name => char.name,
                                :email => tracker.player_email)
        else
          client.emit_failure t('alttracker.staff_update_failed')
        end
      end
    end
  end
end

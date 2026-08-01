module AresMUSH
  module AltTracker
    class RegisterBanCmd
      include CommandHandler

      attr_accessor :target_name, :days

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
        self.target_name = titlecase_arg(args.arg1)
        self.days = integer_arg(args.arg2)
      end

      def check_staff
        return t('dispatcher.not_allowed') unless enactor.has_role?("admin") || enactor.has_role?("staff")
        return nil
      end

      def check_args
        return t('alttracker.character_required') if self.target_name.blank?
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

        tracker = AltTracker.ban_tracker(char, enactor, self.days)

        if tracker
          if tracker.ban_expires
            client.emit_success t('alttracker.ban_temp_success',
                                  :name => char.name,
                                  :email => tracker.player_email,
                                  :days => self.days,
                                  :expires => tracker.ban_expires.strftime('%Y-%m-%d %H:%M'))
          else
            client.emit_success t('alttracker.ban_perm_success',
                                  :name => char.name,
                                  :email => tracker.player_email)
          end
        else
          client.emit_failure t('alttracker.staff_update_failed')
        end
      end
    end
  end
end

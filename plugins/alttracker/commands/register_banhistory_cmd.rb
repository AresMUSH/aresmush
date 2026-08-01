module AresMUSH
  module AltTracker
    class RegisterBanhistoryCmd
      include CommandHandler

      attr_accessor :target_name

      def parse_args
        self.target_name = titlecase_arg(cmd.args)
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

        history = AltTracker.ban_history_for(char)

        if history.nil?
          client.emit_failure t('alttracker.target_not_registered', :name => char.name)
          return
        end

        tracker = char.alt_tracker
        template = BanHistoryTemplate.new(char.name, tracker.player_email, history)
        client.emit template.render
      end
    end
  end
end

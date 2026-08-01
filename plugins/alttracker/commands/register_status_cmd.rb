module AresMUSH
  module AltTracker
    class RegisterStatusCmd
      include CommandHandler

      attr_accessor :target_name

      def parse_args
        self.target_name = titlecase_arg(cmd.args)
      end

      def check_staff_for_target
        return nil if self.target_name.blank?

        unless enactor.has_role?("admin") || enactor.has_role?("staff")
          return t('dispatcher.not_allowed')
        end
        return nil
      end

      def handle
        if self.target_name.blank?
          char = enactor
        else
          char = Character.find_one_by_name(self.target_name)

          if !char
            client.emit_failure t('alttracker.character_not_found')
            return
          end
        end

        data = AltTracker.status_for(char)

        if !data
          client.emit_failure t('alttracker.not_registered')
          return
        end

        template = AltStatusTemplate.new(data, char)
        client.emit template.render
      end
    end
  end
end

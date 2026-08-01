module AresMUSH
  module Pf2e
    class SheetCmd
      include CommandHandler

      attr_accessor :target_name

      def parse_args
        self.target_name = titlecase_arg(cmd.args)
      end

      # Viewing another character's sheet is staff-only for now.
      def check_target_permission
        return nil if self.target_name.blank?
        return nil if enactor.has_permission?("view_sheets") ||
                      enactor.has_role?("admin") ||
                      enactor.has_role?("staff")
        t('dispatcher.not_allowed')
      end

      def handle
        if self.target_name.blank?
          char = enactor
        else
          char = Character.named(self.target_name) || Character.find_one_by_name(self.target_name)
          if !char
            client.emit_failure t('pf2e.character_not_found')
            return
          end
        end

        client.emit Pf2e.render_sheet(char)
      end
    end
  end
end

module AresMUSH
  module Pf2e
    class MoneyCmd
      include CommandHandler

      attr_accessor :target_name

      def parse_args
        self.target_name = titlecase_arg(cmd.args)
      end

      def handle
        if self.target_name.blank?
          char = enactor
        else
          char = Character.named(self.target_name) || Character.find_one_by_name(self.target_name)
          unless char
            client.emit_failure t('pf2e.character_not_found')
            return
          end
          unless Pf2e.can_view_char_sheet?(enactor, char)
            client.emit_failure t('pf2e.view_sheet_denied')
            return
          end
        end

        sheet = Pf2e.find_or_create_sheet(char)
        unless sheet
          client.emit_failure t('pf2e.no_sheet')
          return
        end

        client.emit Pf2e.format_money_status(char)
      end
    end
  end
end

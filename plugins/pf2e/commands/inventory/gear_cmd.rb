module AresMUSH
  module Pf2e
    class GearCmd
      include CommandHandler

      attr_accessor :target_name, :filter_kind

      def parse_args
        # gear [filter] | gear <name> | gear <name>=<filter>
        # filters: equipped, weapon, armor, shield, gear, consumable, custom
        raw = cmd.args ? cmd.args.strip : ""
        if raw.include?("=")
          args = cmd.parse_args(ArgParser.arg1_equals_arg2)
          self.target_name = titlecase_arg(args.arg1)
          self.filter_kind = trim_arg(args.arg2)
        elsif raw.blank?
          self.target_name = nil
          self.filter_kind = nil
        else
          token = raw.split.first.to_s.downcase
          if %w[equipped weapon armor shield gear consumable custom].include?(token)
            self.target_name = nil
            self.filter_kind = token
          else
            self.target_name = titlecase_arg(raw)
            self.filter_kind = nil
          end
        end
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

        kind = self.filter_kind
        kind = nil if kind == "equipped" # equipped is a section filter handled as all + visual; optional later
        kind = nil if kind && !Pf2e::ITEM_KINDS.include?(kind)

        client.emit Pf2e.render_inventory(char, filter_kind: kind)
      end
    end
  end
end

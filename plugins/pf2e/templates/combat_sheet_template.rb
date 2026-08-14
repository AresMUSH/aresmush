module AresMUSH
  module Pf2e
    class CombatSheetTemplate < ErbTemplateRenderer

      attr_accessor :char, :sheet

      def initialize(char, sheet)
        @char = char
        @sheet = sheet
        super File.dirname(__FILE__) + "/combat_sheet.erb"
      end

      def name
        char.name
      end

      def speed
        sheet.speed.to_i
      end

      def hero_points
        sheet.hero_points.to_i
      end

      def focus_points
        sheet.focus_points.to_i
      end

      def hp_display
        hp = sheet.hp || {}
        cur = hp["current"] || hp[:current] || 0
        max = hp["max"] || hp[:max] || 0
        temp = hp["temp"] || hp[:temp] || 0
        temp_bit = temp.to_i > 0 ? " (+#{temp} temp)" : ""
        "#{cur}/#{max}#{temp_bit}"
      end

      def ac_display
        Pf2e.character_ac(sheet).to_s
      end

      def weapon_line
        w = Pf2e.primary_weapon(sheet)
        return "%xhWeapon:%xn (none equipped)" unless w
        mod = Pf2e.weapon_attack_mod_from_item(sheet, w)
        mod_s = mod >= 0 ? "+#{mod}" : mod.to_s
        "%xhWeapon:%xn #{Pf2e.item_display_name(w)} (#{w['id']}) atk #{mod_s}"
      end

      def saves_one_line
        %w[fortitude reflex will].map do |s|
          mod = Pf2e.save_mod(sheet, s)
          mod_str = mod >= 0 ? "+#{mod}" : mod.to_s
          "#{s[0..3].capitalize} #{mod_str}"
        end.join("  ")
      end

      def perception_mod_display
        mod = Pf2e.save_mod(sheet, "perception")
        mod >= 0 ? "+#{mod}" : mod.to_s
      end

      def conditions_block
        conds = sheet.conditions || {}
        return "%xhConditions:%xn (none)" if conds.empty?
        bits = conds.map { |k, v| "#{k}:#{v}" }.join(", ")
        "%xhConditions:%xn #{bits}"
      end
    end
  end
end

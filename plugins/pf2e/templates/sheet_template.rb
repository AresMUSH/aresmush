module AresMUSH
  module Pf2e
    class SheetTemplate < ErbTemplateRenderer

      attr_accessor :char, :sheet

      def initialize(char, sheet)
        @char = char
        @sheet = sheet
        super File.dirname(__FILE__) + "/sheet.erb"
      end

      def name
        char.name
      end

      def level
        sheet.level.to_i
      end

      def ancestry_display
        sheet.ancestry.blank? ? "—" : sheet.ancestry.to_s.tr("_", " ").split.map(&:capitalize).join(" ")
      end

      def heritage_display
        sheet.heritage.blank? ? "—" : sheet.heritage.to_s.tr("_", " ").split.map(&:capitalize).join(" ")
      end

      def class_display
        cc = sheet.charclass || {}
        slug = cc["name"] || cc[:name] || cc["slug"] || cc[:slug]
        return "—" if slug.blank?
        slug.to_s.tr("_", " ").split.map(&:capitalize).join(" ")
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

      # AC needs armor rank/item/dex_cap once equipped gear is on the sheet.
      # Until then, unarmored baseline: rank U, no item bonus, no dex cap.
      def ac_display
        Pf2e.ac(sheet, rank: "U", item_bonus: 0, dex_cap: nil).to_s
      end

      def ability_block
        lines = Pf2e::ABILITY_KEYS.map do |key|
          score = Pf2e.ability_score(sheet, key)
          mod = Pf2e.ability_mod(sheet, key)
          mod_str = mod >= 0 ? "+#{mod}" : mod.to_s
          "  %xh#{key.upcase}%xn #{score} (#{mod_str})"
        end
        lines.join("%r")
      end

      def saves_block
        %w[fortitude reflex will perception].map do |s|
          rank = Pf2e.save_rank(sheet, s)
          mod = Pf2e.save_mod(sheet, s)
          mod_str = mod >= 0 ? "+#{mod}" : mod.to_s
          label = s.capitalize
          "  %xh#{label}%xn #{rank} (#{mod_str})"
        end.join("%r")
      end

      def skills_block
        data = Pf2e.read_data("skills") || {}
        keys = data.keys.sort
        return "  (none defined in data)" if keys.empty?

        lines = keys.map do |sk|
          rank = Pf2e.skill_rank(sheet, sk)
          mod = Pf2e.skill_mod(sheet, sk)
          mod_str = mod >= 0 ? "+#{mod}" : mod.to_s
          if rank == "U"
            "  #{sk.tr('_', ' ')} #{mod_str}"
          else
            "  %xh#{sk.tr('_', ' ')}%xn #{rank} (#{mod_str})"
          end
        end
        lines.join("%r")
      end

      def feats_block
        list = sheet.feats || []
        return "  (none)" if list.empty?
        list.map { |f| "  #{f.to_s.tr('_', ' ')}" }.join("%r")
      end

      def conditions_block
        conds = sheet.conditions || {}
        return "  (none)" if conds.empty?
        conds.map { |k, v| "  #{k}: #{v}" }.join("%r")
      end
    end
  end
end

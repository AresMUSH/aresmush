module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Combat / derived roll keywords for the roll parser
    # Supports: melee, ranged, unarmed, ac, class_dc,
    # spell_dc, spell_attack, and source-qualified forms:
    #   spell_dc:wizard  spell_attack:innate
    # -------------------------------------------------

    def self.combat_keyword?(token)
      return false if token.nil?
      t = token.to_s.strip.downcase
      return true if %w[melee ranged unarmed ac class_dc spell_dc spell_attack].include?(t)
      return true if t =~ /\A(spell_dc|spell_attack|class_dc)[:.][\w]+\z/
      false
    end

    def self.combat_keyword_type(token)
      t = token.to_s.strip.downcase
      case t
      when "ac", /^class_dc/, /^spell_dc/
        :dc
      when "melee", "ranged", "unarmed", /^spell_attack/
        :attack
      else
        :combat
      end
    end

    def self.resolve_combat_keyword(token, char_or_sheet)
      t = token.to_s.strip.downcase
      sheet = sheet_for(char_or_sheet) || char_or_sheet

      case t
      when "melee"
        resolve_melee_attack_mod(sheet)
      when "ranged"
        resolve_ranged_attack_mod(sheet)
      when "unarmed"
        resolve_unarmed_attack_mod(sheet)
      when "ac"
        character_ac(sheet)
      when "class_dc"
        resolve_class_dc(sheet)
      when "spell_dc"
        resolve_spell_keyword_value(sheet, :dc, nil)
      when "spell_attack"
        resolve_spell_keyword_value(sheet, :attack, nil)
      else
        if t =~ /\Aspell_dc[:.]([\w]+)\z/
          resolve_spell_keyword_value(sheet, :dc, $1)
        elsif t =~ /\Aspell_attack[:.]([\w]+)\z/
          resolve_spell_keyword_value(sheet, :attack, $1)
        elsif t =~ /\Aclass_dc[:.]([\w]+)\z/
          resolve_class_dc(sheet)
        else
          0
        end
      end
    end

    def self.resolve_spell_keyword_value(sheet, kind, source)
      key = source.to_s.strip.downcase
      if key == "innate" || key.empty? && magic_sources(sheet) == ["innate"]
        result = if kind == :dc
                   innate_spell_dc(sheet)
                 else
                   innate_spell_attack_mod(sheet)
                 end
        return result[:value] if result[:ok]
      end

      if key == "innate"
        result = if kind == :dc
                   innate_spell_dc(sheet)
                 else
                   innate_spell_attack_mod(sheet)
                 end
        return result[:value] if result[:ok]
        return 0
      end

      result = if kind == :dc
                 magic_spell_dc(sheet, source)
               else
                 magic_spell_attack_mod(sheet, source)
               end
      return result[:value] if result[:ok]
      0
    end

    def self.resolve_class_dc(sheet)
      return 10 unless sheet
      cc = sheet.charclass || {}
      ability = cc["key_ability"] || cc["key"] || "str"
      rank = "T"
      if sheet.proficiencies.is_a?(Hash)
        rank = (sheet.proficiencies["class_dc"] || sheet.proficiencies["class"] || "T").to_s
      end
      class_dc(sheet, ability: ability, rank: rank)
    end

    def self.best_attack_rank(sheet, *categories)
      return "U" unless sheet
      ranks = categories.map { |c| weapon_proficiency_rank(sheet, c).to_s }
      ranks.max_by { |r| teml_order(r) } || "U"
    end

  end
end

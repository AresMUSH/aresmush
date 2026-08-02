module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Sheet-driven combat resolve (table-style, not automation)
    # Used by the roll expression parser as keywords.
    # -------------------------------------------------

    COMBAT_KEYWORDS = %w[
      melee ranged attack unarmed
      spell_attack spellattack spell_atk spellatk
      class_dc classdc
      spell_dc spelldc
    ].freeze

    def self.combat_keyword?(token)
      COMBAT_KEYWORDS.include?(token.to_s.strip.downcase)
    end

    def self.sheet_class_slug(sheet)
      return nil unless sheet
      cc = sheet.charclass || {}
      slug = (cc["slug"] || cc[:slug]).to_s.strip.downcase
      slug.empty? ? nil : slug
    end

    def self.sheet_key_ability(sheet)
      return nil unless sheet
      cc = sheet.charclass || {}
      ability_key(cc["key_ability"] || cc[:key_ability])
    end

    def self.sheet_class_entry(sheet)
      slug = sheet_class_slug(sheet)
      return nil unless slug
      read_data("charclasses", slug)
    end

    def self.best_attack_rank(sheet, *categories)
      entry = sheet_class_entry(sheet)
      attacks = (entry.is_a?(Hash) && entry["attacks"].is_a?(Hash)) ? entry["attacks"] : {}
      best = "U"
      categories.flatten.each do |cat|
        rank = (attacks[cat.to_s] || attacks[cat.to_s.to_sym] || "U").to_s
        best = rank if teml_order(rank) > teml_order(best)
      end
      best
    end

    def self.class_dc_rank(sheet)
      entry = sheet_class_entry(sheet)
      return "T" unless entry.is_a?(Hash)
      (entry["class_dc"] || "T").to_s
    end

    def self.spellcasting_info(sheet)
      entry = sheet_class_entry(sheet)
      return nil unless entry.is_a?(Hash)
      sc = entry["spellcasting"]
      return nil if sc.nil? || sc == false
      return nil unless sc.is_a?(Hash)

      abil = sheet_key_ability(sheet)
      {
        ability: abil,
        rank: (sc["rank"] || "T").to_s,
        tradition: sc["tradition"].to_s,
        type: sc["type"].to_s
      }
    end

    def self.resolve_class_dc(char_or_sheet, other_bonus: 0)
      sheet = sheet_for(char_or_sheet)
      abil = sheet_key_ability(sheet)
      return 10 unless abil
      class_dc(sheet, ability: abil, rank: class_dc_rank(sheet), other_bonus: other_bonus)
    end

    def self.resolve_spell_dc(char_or_sheet, other_bonus: 0)
      sheet = sheet_for(char_or_sheet)
      info = spellcasting_info(sheet)
      return 10 unless info && info[:ability]
      spell_dc(sheet, ability: info[:ability], rank: info[:rank], other_bonus: other_bonus)
    end

    def self.resolve_spell_attack_mod(char_or_sheet, other_bonus: 0)
      sheet = sheet_for(char_or_sheet)
      info = spellcasting_info(sheet)
      return 0 unless info && info[:ability]
      spell_attack_mod(sheet, ability: info[:ability], rank: info[:rank], other_bonus: other_bonus)
    end

    def self.resolve_melee_attack_mod(char_or_sheet, other_bonus: 0)
      sheet = sheet_for(char_or_sheet)
      rank = best_attack_rank(sheet, "unarmed", "simple", "martial")
      attack_mod(sheet, ability: "str", rank: rank, other_bonus: other_bonus)
    end

    def self.resolve_ranged_attack_mod(char_or_sheet, other_bonus: 0)
      sheet = sheet_for(char_or_sheet)
      rank = best_attack_rank(sheet, "simple", "martial")
      attack_mod(sheet, ability: "dex", rank: rank, other_bonus: other_bonus)
    end

    def self.resolve_unarmed_attack_mod(char_or_sheet, other_bonus: 0)
      sheet = sheet_for(char_or_sheet)
      rank = best_attack_rank(sheet, "unarmed")
      attack_mod(sheet, ability: "str", rank: rank, other_bonus: other_bonus)
    end

    def self.resolve_combat_keyword(token, char_or_sheet)
      key = token.to_s.strip.downcase
      case key
      when "melee", "attack"
        resolve_melee_attack_mod(char_or_sheet)
      when "ranged"
        resolve_ranged_attack_mod(char_or_sheet)
      when "unarmed"
        resolve_unarmed_attack_mod(char_or_sheet)
      when "spell_attack", "spellattack", "spell_atk", "spellatk"
        resolve_spell_attack_mod(char_or_sheet)
      when "class_dc", "classdc"
        resolve_class_dc(char_or_sheet)
      when "spell_dc", "spelldc"
        resolve_spell_dc(char_or_sheet)
      else
        0
      end
    end

    def self.combat_keyword_type(token)
      key = token.to_s.strip.downcase
      case key
      when "class_dc", "classdc", "spell_dc", "spelldc"
        :dc
      when "spell_attack", "spellattack", "spell_atk", "spellatk"
        :spell_attack
      when "melee", "ranged", "attack", "unarmed"
        :attack
      else
        :unknown
      end
    end

  end
end

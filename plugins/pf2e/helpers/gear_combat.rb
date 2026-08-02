module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Combat stats from equipped inventory
    # Armor → AC; weapons → attack item bonus + damage dice/runes
    # -------------------------------------------------

    def self.equipped_armor(char_or_sheet)
      equipped_items(char_or_sheet, kind: "armor").first
    end

    def self.equipped_shield(char_or_sheet)
      equipped_items(char_or_sheet, kind: "shield").first
    end

    def self.equipped_weapons(char_or_sheet)
      equipped_items(char_or_sheet, kind: "weapon")
    end

    def self.primary_weapon(char_or_sheet)
      equipped_weapons(char_or_sheet).first
    end

    def self.weapon_catalog(entry)
      return nil unless entry
      catalog_entry("weapon", entry["slug"]) || read_data("weapons", entry["slug"].to_s)
    end

    def self.armor_catalog(entry)
      return nil unless entry
      catalog_entry("armor", entry["slug"]) || read_data("armor", entry["slug"].to_s)
    end

    def self.item_potency(entry)
      runes = entry.is_a?(Hash) ? entry["runes"] : nil
      return 0 unless runes.is_a?(Hash)
      runes["potency"].to_i
    end

    def self.item_striking_dice(entry)
      runes = entry.is_a?(Hash) ? entry["runes"] : nil
      return 0 unless runes.is_a?(Hash)
      runes["striking"].to_i
    end

    def self.item_resilient(entry)
      runes = entry.is_a?(Hash) ? entry["runes"] : nil
      return 0 unless runes.is_a?(Hash)
      runes["resilient"].to_i
    end

    def self.armor_proficiency_rank(sheet, category)
      entry = sheet_class_entry(sheet)
      defenses = (entry.is_a?(Hash) && entry["defenses"].is_a?(Hash)) ? entry["defenses"] : {}
      cat = category.to_s.downcase
      (defenses[cat] || defenses[cat.to_sym] || "U").to_s
    end

    def self.weapon_proficiency_rank(sheet, category)
      entry = sheet_class_entry(sheet)
      attacks = (entry.is_a?(Hash) && entry["attacks"].is_a?(Hash)) ? entry["attacks"] : {}
      cat = category.to_s.downcase
      (attacks[cat] || attacks[cat.to_sym] || "U").to_s
    end

    # Full AC from sheet + equipped armor (+ optional raised shield later).
    def self.character_ac(char_or_sheet, other_bonus: 0, raise_shield: false)
      sheet = sheet_for(char_or_sheet)
      armor = equipped_armor(sheet)

      if armor
        cat = armor_catalog(armor) || {}
        category = (cat["category"] || "light").to_s
        item_bonus = cat["ac_bonus"].to_i + item_potency(armor) + item_resilient(armor)
        dex_cap = cat.key?("dex_cap") ? cat["dex_cap"] : nil
        rank = armor_proficiency_rank(sheet, category)
      else
        item_bonus = 0
        dex_cap = nil
        rank = armor_proficiency_rank(sheet, "unarmored")
        rank = "U" if rank.to_s.empty?
      end

      shield_bonus = 0
      if raise_shield
        shield = equipped_shield(sheet)
        if shield
          scat = catalog_entry("shield", shield["slug"]) || read_data("items", shield["slug"].to_s) || {}
          shield_bonus = scat["ac_bonus"].to_i
        end
      end

      ac(sheet,
         rank: rank,
         item_bonus: item_bonus,
         other_bonus: other_bonus.to_i + shield_bonus,
         dex_cap: dex_cap)
    end

    def self.weapon_traits(entry)
      cat = weapon_catalog(entry)
      return [] unless cat.is_a?(Hash)
      Array(cat["traits"]).map { |t| t.to_s.downcase }
    end

    def self.weapon_is_ranged?(entry)
      cat = weapon_catalog(entry)
      return false unless cat.is_a?(Hash)
      !cat["range"].nil? && cat["range"].to_i > 0
    end

    def self.weapon_attack_ability(entry)
      traits = weapon_traits(entry)
      if weapon_is_ranged?(entry)
        return "dex" unless traits.include?("propulsive")
        # propulsive still uses Dex for attack
        return "dex"
      end
      return "dex" if traits.include?("finesse")
      "str"
    end

    def self.weapon_damage_ability_mod(sheet, entry)
      traits = weapon_traits(entry)
      if weapon_is_ranged?(entry)
        return 0 unless traits.include?("propulsive")
        # propulsive: add half Str (floor 0) if Str positive
        str = ability_mod(sheet, "str")
        return 0 if str <= 0
        str / 2
      elsif traits.include?("finesse")
        # Finesse weapons still use Str for damage unless an effect says otherwise
        ability_mod(sheet, "str")
      else
        ability_mod(sheet, "str")
      end
    end

    def self.weapon_attack_mod_from_item(char_or_sheet, weapon_entry, other_bonus: 0)
      sheet = sheet_for(char_or_sheet)
      cat = weapon_catalog(weapon_entry) || {}
      category = (cat["category"] || "simple").to_s
      rank = weapon_proficiency_rank(sheet, category)
      ability = weapon_attack_ability(weapon_entry)
      item_bonus = item_potency(weapon_entry)

      attack_mod(sheet,
                 ability: ability,
                 rank: rank,
                 item_bonus: item_bonus,
                 other_bonus: other_bonus)
    end

    # Striking rune adds weapon damage dice of the same size as the base die.
    def self.weapon_damage_spec_from_item(weapon_entry)
      cat = weapon_catalog(weapon_entry)
      return nil unless cat.is_a?(Hash) && cat["damage"].is_a?(Hash)
      dmg = cat["damage"]
      dice = dmg["dice"].to_i + item_striking_dice(weapon_entry)
      sides = dmg["sides"].to_i
      { dice: dice, sides: sides, type: dmg["type"] }
    end

    def self.resolve_melee_attack_mod(char_or_sheet, other_bonus: 0)
      sheet = sheet_for(char_or_sheet)
      weapon = primary_weapon(sheet)
      if weapon && !weapon_is_ranged?(weapon)
        return weapon_attack_mod_from_item(sheet, weapon, other_bonus: other_bonus)
      end
      rank = best_attack_rank(sheet, "unarmed", "simple", "martial")
      attack_mod(sheet, ability: "str", rank: rank, other_bonus: other_bonus)
    end

    def self.resolve_ranged_attack_mod(char_or_sheet, other_bonus: 0)
      sheet = sheet_for(char_or_sheet)
      weapon = equipped_weapons(sheet).find { |w| weapon_is_ranged?(w) } || primary_weapon(sheet)
      if weapon && weapon_is_ranged?(weapon)
        return weapon_attack_mod_from_item(sheet, weapon, other_bonus: other_bonus)
      end
      rank = best_attack_rank(sheet, "simple", "martial")
      attack_mod(sheet, ability: "dex", rank: rank, other_bonus: other_bonus)
    end

    def self.resolve_unarmed_attack_mod(char_or_sheet, other_bonus: 0)
      sheet = sheet_for(char_or_sheet)
      rank = best_attack_rank(sheet, "unarmed")
      attack_mod(sheet, ability: "str", rank: rank, other_bonus: other_bonus)
    end

  end
end

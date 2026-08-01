module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Character / sheet helpers
    # Basic accessors and derived values that everything else builds on.
    # -------------------------------------------------

    # Canonical ability keys used in the sheet hash.
    ABILITY_KEYS = %w[str dex con int wis cha].freeze unless const_defined?(:ABILITY_KEYS)

    # Map common aliases → canonical key.
    ABILITY_ALIASES = {
      "str" => "str", "strength"     => "str",
      "dex" => "dex", "dexterity"    => "dex",
      "con" => "con", "constitution" => "con",
      "int" => "int", "intelligence" => "int",
      "wis" => "wis", "wisdom"       => "wis",
      "cha" => "cha", "charisma"     => "cha"
    }.freeze unless const_defined?(:ABILITY_ALIASES)

    # Normalize any reasonable ability name/symbol to the canonical key ("str", etc.).
    # Returns nil if the input is not a recognized ability.
    def self.ability_key(name)
      return nil if name.nil?
      ABILITY_ALIASES[name.to_s.strip.downcase]
    end

    # Return the Pf2eSheet for a Character, or the object itself if it is already a sheet.
    # Returns nil if no sheet exists.
    def self.sheet_for(char_or_sheet)
      return nil if char_or_sheet.nil?
      return char_or_sheet if char_or_sheet.is_a?(Pf2eSheet)
      char_or_sheet.pf2e_sheet
    end

    # Find existing sheet or create one and link it 1:1 to the character.
    # Returns the Pf2eSheet, or nil if char is nil.
    def self.find_or_create_sheet(char)
      return nil if char.nil?
      return char if char.is_a?(Pf2eSheet)

      sheet = char.pf2e_sheet
      return sheet if sheet

      sheet = Pf2eSheet.create(character: char)
      char.update(pf2e_sheet: sheet)
      sheet
    end

    # Integer ability score. which: :current (default) or :base
    # Trusts the sheet's always-populated abilities hash.
    def self.ability_score(char_or_sheet, ability, which = :current)
      sheet = sheet_for(char_or_sheet)
      return nil unless sheet

      key = ability_key(ability)
      return nil unless key

      idx = (which == :base) ? 0 : 1
      sheet.abilities[key][idx].to_i
    end

    # PF2e ability modifier: floor((score - 10) / 2)
    # Defaults to the *current* score. Missing sheet/ability → 0.
    def self.ability_mod(char_or_sheet, ability, which = :current)
      score = ability_score(char_or_sheet, ability, which)
      return 0 if score.nil?
      ((score - 10) / 2).floor
    end

    # Set base and/or current ability score.
    # Pass only the values you want to change; omitted side is left alone.
    # Returns the updated [base, current] or nil on failure.
    def self.set_ability(char_or_sheet, ability, base: nil, current: nil)
      sheet = sheet_for(char_or_sheet)
      return nil unless sheet

      key = ability_key(ability)
      return nil unless key

      entry = sheet.abilities[key].dup
      entry[0] = base.to_i unless base.nil?
      entry[1] = current.to_i unless current.nil?

      abilities = sheet.abilities.dup
      abilities[key] = entry
      sheet.update(abilities: abilities)
      entry
    end

    # Set a skill rank on the sheet (sparse hash). Use nil or "U" to clear.
    def self.set_skill_rank(char_or_sheet, skill, rank)
      sheet = sheet_for(char_or_sheet)
      return nil unless sheet

      key = skill.to_s.strip.downcase
      skills = sheet.skills.dup

      if rank.nil? || rank.to_s.strip.empty? || rank.to_s.strip.upcase == "U"
        skills.delete(key)
      else
        skills[key] = rank.to_s.strip.upcase
      end

      sheet.update(skills: skills)
      skills[key]
    end

    # Set a save/Perception rank on the sheet (sparse hash). Use nil or "U" to clear.
    def self.set_save_rank(char_or_sheet, name, rank)
      sheet = sheet_for(char_or_sheet)
      return nil unless sheet

      key = save_key(name)
      return nil unless key

      saves = sheet.saves.dup

      if rank.nil? || rank.to_s.strip.empty? || rank.to_s.strip.upcase == "U"
        saves.delete(key)
      else
        saves[key] = rank.to_s.strip.upcase
      end

      sheet.update(saves: saves)
      saves[key]
    end

    # -------------------------------------------------
    # Class DC / spell attack / spell DC
    # Same TEML + key ability + level pattern as skills.
    # Callers pass key ability and rank until charclass
    # data drives them automatically.
    # -------------------------------------------------

    # Class DC = 10 + key ability mod + proficiency (+ level if trained+)
    def self.class_dc(char_or_sheet, ability:, rank: "T", other_bonus: 0, level: nil)
      10 + proficiency_mod(char_or_sheet, ability: ability, rank: rank, level: level) + other_bonus.to_i
    end

    # Spell attack modifier = key ability mod + proficiency (+ level if trained+)
    def self.spell_attack_mod(char_or_sheet, ability:, rank: "T", other_bonus: 0, level: nil)
      proficiency_mod(char_or_sheet, ability: ability, rank: rank, level: level) + other_bonus.to_i
    end

    # Spell DC = 10 + key ability mod + proficiency (+ level if trained+)
    def self.spell_dc(char_or_sheet, ability:, rank: "T", other_bonus: 0, level: nil)
      10 + proficiency_mod(char_or_sheet, ability: ability, rank: rank, level: level) + other_bonus.to_i
    end

    # Shared building block: ability mod + TEML proficiency (+ level if trained+).
    def self.proficiency_mod(char_or_sheet, ability:, rank: "U", level: nil)
      sheet = sheet_for(char_or_sheet)
      abil_mod = ability_mod(sheet || char_or_sheet, ability)
      prof = teml_to_bonus(rank)

      char_level = level
      if char_level.nil?
        char_level = sheet ? sheet.level.to_i : 0
      end

      if prof > 0
        abil_mod + prof + char_level.to_i
      else
        abil_mod
      end
    end

  end
end

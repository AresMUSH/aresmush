module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Save / Perception helpers
    # -------------------------------------------------

    # Normalize a save/perception name to the canonical key.
    # Accepts "fort", "fortitude", "ref", "reflex", "will", "perc", "perception", etc.
    def self.save_key(name)
      return nil if name.nil?
      raw = name.to_s.strip.downcase

      case raw
      when "fort", "fortitude" then "fortitude"
      when "ref", "reflex"     then "reflex"
      when "will"              then "will"
      when "perc", "perception" then "perception"
      else
        # Fall back to whatever is in the data file
        read_data("saves", raw) ? raw : nil
      end
    end

    # Ability key linked to a save/perception (from static data).
    def self.save_ability(name)
      key = save_key(name)
      return nil unless key
      entry = read_data("saves", key)
      return nil unless entry.is_a?(Hash)
      entry["ability"]
    end

    # TEML rank for a save/perception. Missing key = Untrained ("U").
    def self.save_rank(char_or_sheet, name)
      sheet = sheet_for(char_or_sheet)
      return "U" unless sheet

      key = save_key(name)
      return "U" unless key

      rank = sheet.saves[key]
      rank.nil? || rank.to_s.strip.empty? ? "U" : rank.to_s.strip.upcase
    end

    # Full save / perception modifier (PF2e core rules).
    # Untrained  → ability mod only
    # Trained+   → ability mod + proficiency bonus + level
    def self.save_mod(char_or_sheet, name)
      sheet = sheet_for(char_or_sheet)
      return 0 unless sheet

      abil = save_ability(name)
      return 0 unless abil

      abil_mod = ability_mod(sheet, abil)
      rank     = save_rank(sheet, name)
      prof     = teml_to_bonus(rank)

      if prof > 0
        abil_mod + prof + sheet.level.to_i
      else
        abil_mod
      end
    end

    # Make a save or Perception check.
    # Same return shape as skill_roll / attack_roll.
    # Optional dc: adds :degree via degree_of_success (nat 20 / nat 1 applied).
    def self.save_roll(char_or_sheet, name, other_bonus: 0, dc: nil)
      key = save_key(name) || name.to_s.strip.downcase
      mod = save_mod(char_or_sheet, key) + other_bonus.to_i

      dice_rolls = roll_dice(1, 20)
      d20 = dice_rolls.first
      total = d20 + mod

      result = {
        expression: "1d20 + #{key}",
        total: total,
        modifier: mod,
        d20: d20,
        save: key,
        parts: [
          { raw: "1d20", type: :dice, rolls: dice_rolls, value: d20 },
          { raw: key, type: :save, value: mod }
        ]
      }

      if !dc.nil?
        result[:degree] = degree_of_success(total, dc, d20: d20)
      end

      result
    end

  end
end

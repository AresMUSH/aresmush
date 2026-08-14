module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Skill helpers
    # -------------------------------------------------

    # Return the ability key associated with a skill (from static data).
    # Lore skills (slug ends in _lore, or exact "lore") default to Int.
    def self.skill_ability(skill)
      return nil if skill.nil?
      key = skill.to_s.strip.downcase
      entry = read_data("skills", key)
      if entry.is_a?(Hash) && entry["ability"]
        return entry["ability"]
      end
      return "int" if key == "lore" || key.end_with?("_lore")
      nil
    end

    def self.skill_rank(char_or_sheet, skill)
      sheet = sheet_for(char_or_sheet)
      return "U" unless sheet

      key = skill.to_s.strip.downcase
      rank = sheet.skills[key]
      rank.nil? || rank.to_s.strip.empty? ? "U" : rank.to_s.strip.upcase
    end

    def self.skill_mod(char_or_sheet, skill)
      sheet = sheet_for(char_or_sheet)
      return 0 unless sheet

      abil = skill_ability(skill)
      return 0 unless abil

      abil_mod = ability_mod(sheet, abil)
      rank     = skill_rank(sheet, skill)
      prof     = teml_to_bonus(rank)

      if prof > 0
        abil_mod + prof + sheet.level.to_i
      else
        abil_mod
      end
    end

    def self.skill_roll(char_or_sheet, skill, other_bonus: 0, dc: nil)
      key = skill.to_s.strip.downcase
      mod = skill_mod(char_or_sheet, key) + other_bonus.to_i

      dice_rolls = roll_dice(1, 20)
      d20 = dice_rolls.first
      total = d20 + mod

      result = {
        expression: "1d20 + #{key}",
        total: total,
        modifier: mod,
        d20: d20,
        skill: key,
        parts: [
          { raw: "1d20", type: :dice, rolls: dice_rolls, value: d20 },
          { raw: key, type: :skill, value: mod }
        ]
      }

      if !dc.nil?
        result[:degree] = degree_of_success(total, dc, d20: d20)
      end

      result
    end

  end
end

module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Combat / attack helpers
    # No weapons YAML required for attack_mod / attack_roll —
    # callers supply ability, rank, and bonuses.
    # damage_roll uses the same explicit style; weapons.yml
    # is available later for lookups.
    # -------------------------------------------------

    # Attack modifier (PF2e core).
    # Untrained  → ability mod only
    # Trained+   → ability mod + proficiency bonus + level
    # Plus optional item_bonus and other_bonus.
    def self.attack_mod(char_or_sheet, ability:, rank: "U", item_bonus: 0, other_bonus: 0, level: nil)
      sheet = sheet_for(char_or_sheet)

      abil_mod = ability_mod(sheet || char_or_sheet, ability)
      prof     = teml_to_bonus(rank)

      char_level = level
      if char_level.nil?
        char_level = sheet ? sheet.level.to_i : 0
      end

      base = if prof > 0
               abil_mod + prof + char_level.to_i
             else
               abil_mod
             end

      base + item_bonus.to_i + other_bonus.to_i
    end

    # Make an attack roll.
    # Optional dc: adds :degree via degree_of_success (nat 20 / nat 1 applied).
    def self.attack_roll(char_or_sheet, ability:, rank: "U", item_bonus: 0, other_bonus: 0, level: nil, dc: nil)
      mod = attack_mod(
        char_or_sheet,
        ability: ability,
        rank: rank,
        item_bonus: item_bonus,
        other_bonus: other_bonus,
        level: level
      )

      dice_rolls = roll_dice(1, 20)
      d20 = dice_rolls.first
      total = d20 + mod

      result = {
        expression: "1d20 + attack",
        total: total,
        modifier: mod,
        d20: d20,
        parts: [
          { raw: "1d20", type: :dice, rolls: dice_rolls, value: d20 },
          { raw: "attack", type: :attack, value: mod }
        ]
      }

      if !dc.nil?
        result[:degree] = degree_of_success(total, dc, d20: d20)
      end

      result
    end

    # -------------------------------------------------
    # Damage
    # -------------------------------------------------

    # Roll weapon (or unarmed) damage, applying degree of success.
    #
    # PF2e critical hit rule used here:
    #   Critical success → double the *weapon damage dice only*
    #   Ability mod, extra dice (runes, etc.), and flat bonuses are NOT doubled
    #   unless a specific effect says otherwise (pass those already-doubled
    #   if needed via extra_dice / other_bonus).
    #
    # Failure / critical failure → 0 damage (standard Strike).
    #
    # Args:
    #   damage_dice:  "1d8" or { dice: 1, sides: 8 }  — base weapon dice
    #   ability_mod:  integer (STR/DEX etc. applied to damage)
    #   extra_dice:   array of "1d6"-style strings (striking, sneak attack, …)
    #                 rolled once; not doubled on crit unless you pre-double them
    #   other_bonus:  flat bonus (weapon specialization, status, …)
    #   degree:       :critical_success / :success / :failure / :critical_failure
    #                 (default :success)
    #   damage_type:  optional label stored on the result
    #
    # Returns hash with :total, :degree, :damage_type, :parts
    def self.damage_roll(damage_dice:, ability_mod: 0, extra_dice: [], other_bonus: 0, degree: :success, damage_type: nil)
      degree = degree.to_sym

      # Misses deal no damage on a normal Strike
      if degree == :failure || degree == :critical_failure
        return {
          total: 0,
          degree: degree,
          damage_type: damage_type,
          parts: []
        }
      end

      parts = []
      total = 0

      # --- weapon dice (doubled on critical success) ---
      count, sides = parse_dice(damage_dice)
      if degree == :critical_success
        count *= 2
      end
      weapon_rolls = roll_dice(count, sides)
      weapon_value = weapon_rolls.sum
      parts << {
        raw: "#{count}d#{sides}",
        type: :weapon_dice,
        rolls: weapon_rolls,
        value: weapon_value
      }
      total += weapon_value

      # --- ability modifier (not doubled) ---
      abil = ability_mod.to_i
      if abil != 0
        parts << { raw: "ability", type: :ability, value: abil }
        total += abil
      end

      # --- extra dice (runes, precision, etc.; not auto-doubled) ---
      Array(extra_dice).each do |spec|
        ec, es = parse_dice(spec)
        next if ec <= 0 || es <= 0
        rolls = roll_dice(ec, es)
        value = rolls.sum
        parts << { raw: "#{ec}d#{es}", type: :extra_dice, rolls: rolls, value: value }
        total += value
      end

      # --- flat bonus (not doubled) ---
      bonus = other_bonus.to_i
      if bonus != 0
        parts << { raw: "bonus", type: :flat, value: bonus }
        total += bonus
      end

      {
        total: total,
        degree: degree,
        damage_type: damage_type,
        parts: parts
      }
    end

    # Convenience: look up a weapon slug and roll its base damage with the
    # given degree / modifiers. Returns nil if the weapon is unknown.
    # (Requires data/weapons.yml to be populated for that slug.)
    def self.weapon_damage_roll(weapon_slug, ability_mod: 0, extra_dice: [], other_bonus: 0, degree: :success)
      entry = read_data("weapons", weapon_slug.to_s.strip.downcase)
      return nil unless entry.is_a?(Hash) && entry["damage"].is_a?(Hash)

      dmg = entry["damage"]
      dice_spec = { dice: dmg["dice"].to_i, sides: dmg["sides"].to_i }

      damage_roll(
        damage_dice: dice_spec,
        ability_mod: ability_mod,
        extra_dice: extra_dice,
        other_bonus: other_bonus,
        degree: degree,
        damage_type: dmg["type"]
      )
    end

    # -------------------------------------------------
    # Multiple attack penalty
    # -------------------------------------------------

    # MAP for the Nth attack this turn (1-based).
    # attacks_made: how many Strikes already made this turn (0 = first attack)
    # agile: true → -4 / -8 instead of -5 / -10
    # Returns 0, -4/-5, or -8/-10.
    def self.map_penalty(attacks_made: 0, agile: false)
      n = attacks_made.to_i
      return 0 if n <= 0

      second = agile ? -4 : -5
      third  = agile ? -8 : -10
      n == 1 ? second : third
    end

    # -------------------------------------------------
    # Armor Class
    # -------------------------------------------------

    # Armor Class (PF2e core).
    # 10 + Dex (optionally capped by armor) + proficiency (+ level if trained+)
    #   + item_bonus + other_bonus
    #
    # rank:        armor proficiency TEML (default "U")
    # item_bonus:  armor item bonus (default 0)
    # other_bonus: circumstance/status/etc. (default 0)
    # dex_cap:     max Dex bonus allowed by armor (nil = no cap)
    # level:       override; otherwise taken from the sheet
    def self.ac(char_or_sheet, rank: "U", item_bonus: 0, other_bonus: 0, dex_cap: nil, level: nil)
      sheet = sheet_for(char_or_sheet)

      dex = ability_mod(sheet || char_or_sheet, "dex")
      unless dex_cap.nil?
        dex = [dex, dex_cap.to_i].min
      end

      prof = teml_to_bonus(rank)

      char_level = level
      if char_level.nil?
        char_level = sheet ? sheet.level.to_i : 0
      end

      proficiency_part = if prof > 0
                           prof + char_level.to_i
                         else
                           0
                         end

      10 + dex + proficiency_part + item_bonus.to_i + other_bonus.to_i
    end

    # ---------- internals ----------

    # Accept "1d8", "d6", or { dice: 1, sides: 8 } → [count, sides]
    def self.parse_dice(spec)
      case spec
      when Hash
        [spec[:dice] || spec["dice"] || 1, spec[:sides] || spec["sides"] || 1]
      when String
        if spec =~ /\A(\d*)d(\d+)\z/i
          count = $1.empty? ? 1 : $1.to_i
          sides = $2.to_i
          [count, sides]
        else
          [0, 0]
        end
      when Array
        [spec[0].to_i, spec[1].to_i]
      else
        [0, 0]
      end
    end

  end
end

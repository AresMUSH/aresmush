module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Roll parsing & evaluation
    # -------------------------------------------------

    # Evaluate a dice expression string.
    # Examples:
    #   "1d20 + str + 1d6 - 2"
    #   "athletics"          → auto 1d20 + skill mod
    #   "fortitude + 2"      → auto 1d20 + save mod + 2
    #   "str"                → auto 1d20 + ability mod
    #
    # Returns a hash:
    # {
    #   expression: final expression used,
    #   total:      integer final result,
    #   parts: [
    #     { raw: "1d20",      type: :dice,    rolls: [14], value: 14 },
    #     { raw: "athletics", type: :skill,   value: 7 },
    #     ...
    #   ]
    # }
    def self.roll(expression, char_or_sheet = nil)
      expr = expression.to_s.strip

      # No dice notation present → this is a check; prepend 1d20
      unless expr =~ /\d*d\d+/i
        expr = "1d20 + #{expr}"
      end

      parts = []
      total = 0

      tokenize(expr).each do |sign, token|
        part = evaluate_token(token, sign, char_or_sheet)
        parts << part
        total += part[:value]
      end

      {
        expression: expr,
        total: total,
        parts: parts
      }
    end

    # Roll NdS and return the individual results as an array.
    def self.roll_dice(count, sides)
      count = [count.to_i, 0].max
      sides = [sides.to_i, 1].max
      Array.new(count) { rand(1..sides) }
    end

    # ---------- internals ----------

    # Split expression into [sign, token] pairs.
    # "1d20 + str - 2" → [["+", "1d20"], ["+", "str"], ["-", "2"]]
    def self.tokenize(expr)
      s = expr.gsub(/\s+/, "")
      s = "+#{s}" unless s.start_with?("+", "-")

      tokens = []
      s.scan(/([+-])([^+-]+)/) do |sign, token|
        tokens << [sign, token]
      end
      tokens
    end

    def self.evaluate_token(token, sign, char_or_sheet)
      multiplier = (sign == "-") ? -1 : 1
      raw = token

      # Dice: NdS or dS
      if token =~ /\A(\d*)d(\d+)\z/i
        count = $1.empty? ? 1 : $1.to_i
        sides = $2.to_i
        rolls = roll_dice(count, sides)
        value = rolls.sum * multiplier
        return { raw: raw, type: :dice, rolls: rolls, value: value }
      end

      # Flat integer
      if token =~ /\A\d+\z/
        value = token.to_i * multiplier
        return { raw: raw, type: :flat, value: value }
      end

      # Ability (str, dex, …)
      if ability_key(token)
        mod = ability_mod(char_or_sheet, token)
        return { raw: raw, type: :ability, value: mod * multiplier }
      end

      # Skill (athletics, stealth, …)
      if skill_ability(token)
        mod = skill_mod(char_or_sheet, token)
        return { raw: raw, type: :skill, value: mod * multiplier }
      end

      # Save / Perception (fortitude, reflex, will, perception)
      if save_key(token)
        mod = save_mod(char_or_sheet, token)
        return { raw: raw, type: :save, value: mod * multiplier }
      end

      # Unknown term → 0 so the roll still completes
      { raw: raw, type: :unknown, value: 0 }
    end

  end
end

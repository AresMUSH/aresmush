module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Roll parsing & evaluation
    # -------------------------------------------------

    # Evaluate a dice expression string.
    # Examples:
    #   "1d20 + str + 1d6 - 2"
    #   "athletics"           → auto 1d20 + skill mod
    #   "melee"               → auto 1d20 + melee attack
    #   "spell_attack"        → auto 1d20 + spell attack
    #   "fortitude + 2"
    #
    # Returns { expression:, total:, parts: [...] }
    def self.roll(expression, char_or_sheet = nil)
      expr = expression.to_s.strip

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

    def self.roll_dice(count, sides)
      count = [count.to_i, 0].max
      sides = [sides.to_i, 1].max
      Array.new(count) { rand(1..sides) }
    end

    # Resolve a DC that may be a number or a combat keyword (class_dc, spell_dc).
    # Returns integer or nil.
    def self.resolve_dc_argument(raw, char_or_sheet = nil)
      return nil if raw.nil?
      s = raw.to_s.strip.downcase
      return s.to_i if s =~ /\A\d+\z/
      return resolve_combat_keyword(s, char_or_sheet) if combat_keyword?(s) && combat_keyword_type(s) == :dc
      nil
    end

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

      if token =~ /\A(\d*)d(\d+)\z/i
        count = $1.empty? ? 1 : $1.to_i
        sides = $2.to_i
        rolls = roll_dice(count, sides)
        value = rolls.sum * multiplier
        return { raw: raw, type: :dice, rolls: rolls, value: value }
      end

      if token =~ /\A\d+\z/
        value = token.to_i * multiplier
        return { raw: raw, type: :flat, value: value }
      end

      if ability_key(token)
        mod = ability_mod(char_or_sheet, token)
        return { raw: raw, type: :ability, value: mod * multiplier }
      end

      if skill_ability(token)
        mod = skill_mod(char_or_sheet, token)
        return { raw: raw, type: :skill, value: mod * multiplier }
      end

      if save_key(token)
        mod = save_mod(char_or_sheet, token)
        return { raw: raw, type: :save, value: mod * multiplier }
      end

      if combat_keyword?(token)
        mod = resolve_combat_keyword(token, char_or_sheet)
        return {
          raw: raw,
          type: combat_keyword_type(token),
          value: mod * multiplier
        }
      end

      { raw: raw, type: :unknown, value: 0 }
    end

  end
end

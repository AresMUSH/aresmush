module AresMUSH
  module Pf2e

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

    def self.resolve_dc_argument(raw, char_or_sheet = nil)
      return nil if raw.nil?
      s = raw.to_s.strip.downcase
      return s.to_i if s =~ /\A\d+\z/
      return resolve_combat_keyword(s, char_or_sheet) if combat_keyword?(s) && combat_keyword_type(s) == :dc
      nil
    end

    # Shared display string for CLI, scene, and job comments.
    def self.format_roll_message(enactor, result, degree: nil, dc: nil, dc_label: nil)
      parts_str = result[:parts].map { |p| format_roll_part(p) }.join(" ")

      lines = []
      lines << "#{enactor.name} rolls #{result[:expression]}"
      lines << "  #{parts_str}"
      lines << "  Total: #{result[:total]}"

      if !degree.nil?
        label = dc_label || dc
        lines << "  vs DC #{dc} (#{label}): #{format_degree_label(degree)}"
      end

      lines.join("\n")
    end

    def self.format_roll_part(part)
      case part[:type]
      when :dice
        rolls = Array(part[:rolls]).join(",")
        val = part[:value]
        val < 0 ? "#{part[:raw]}(#{rolls})=#{val}" : "+#{part[:raw]}(#{rolls})=#{val}"
      when :flat
        val = part[:value]
        val < 0 ? "#{val}" : "+#{val}"
      else
        val = part[:value]
        label = part[:raw]
        val < 0 ? "#{label}(#{val})" : "+#{label}(#{val})"
      end
    end

    def self.format_degree_label(degree)
      case degree
      when :critical_success then "Critical Success"
      when :success          then "Success"
      when :failure          then "Failure"
      when :critical_failure then "Critical Failure"
      else degree.to_s
      end
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

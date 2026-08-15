module AresMUSH
  module Pf2e

    # Loads after staff.rb. Extends staff_set for full Focus Point paths and
    # ensures staff_reset_sheet clears focus_max.

    class << self
      unless method_defined?(:staff_set_without_focus_pool)
        alias_method :staff_set_without_focus_pool, :staff_set
      end
      unless method_defined?(:staff_reset_sheet_without_focus_max)
        alias_method :staff_reset_sheet_without_focus_max, :staff_reset_sheet
      end
    end

    def self.staff_set(enactor, char_name, field_path)
      blocked = staff_require_permission(enactor)
      return blocked if blocked

      result = staff_ensure_sheet(char_name)
      return result unless result[:ok]

      sheet = result[:sheet]
      char = result[:char]
      raw_parts = field_path.to_s.strip.split("/").map { |p| p.strip }.reject(&:empty?)
      parts = raw_parts.map { |p| p.downcase }
      return staff_set_without_focus_pool(enactor, char_name, field_path) if parts.empty?

      field = parts[0]
      if field == "focus" || field == "focus_points"
        return staff_set_focus_pool(char, sheet, parts)
      end

      staff_set_without_focus_pool(enactor, char_name, field_path)
    end

    def self.staff_set_focus_pool(char, sheet, parts)
      sub = parts[1]
      return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if sub.nil?

      if sub == "max"
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if parts[2].nil?
        r = set_focus_max(sheet, parts[2])
        return r.merge(char: char, sheet: sheet) unless r[:ok]
        { ok: true, error: nil, char: char, sheet: sheet,
          summary: "focus_max=#{r[:max]} (current=#{r[:current]})" }
      elsif sub == "current"
        return { ok: false, error: "pf2e.staff_set_usage", char: char, sheet: sheet } if parts[2].nil?
        r = set_focus_current(sheet, parts[2])
        return r.merge(char: char, sheet: sheet) unless r[:ok]
        { ok: true, error: nil, char: char, sheet: sheet,
          summary: "focus_points=#{r[:current]}/#{r[:max]}" }
      elsif %w[restore full reset].include?(sub)
        r = restore_focus_to_max!(sheet)
        return r.merge(char: char, sheet: sheet) unless r[:ok]
        { ok: true, error: nil, char: char, sheet: sheet,
          summary: "focus restored #{r[:current]}/#{r[:max]}" }
      elsif %w[inc increase].include?(sub)
        delta = parts[2] ? parts[2].to_i : 1
        r = increase_focus_max!(sheet, delta: delta)
        return r.merge(char: char, sheet: sheet) unless r[:ok]
        { ok: true, error: nil, char: char, sheet: sheet,
          summary: "focus_max +#{delta} -> #{r[:max]} (current=#{r[:current]})" }
      else
        r = set_focus_current(sheet, sub)
        return r.merge(char: char, sheet: sheet) unless r[:ok]
        { ok: true, error: nil, char: char, sheet: sheet,
          summary: "focus_points=#{r[:current]}/#{r[:max]}" }
      end
    end

    def self.staff_reset_sheet(enactor, char_name)
      r = staff_reset_sheet_without_focus_max(enactor, char_name)
      return r unless r[:ok]
      sheet = r[:sheet]
      sheet.update(focus_max: 0, focus_points: 0) if sheet
      r
    end

  end
end

module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Focus Points (PF2e Remaster)
    #
    # Current: sheet.focus_points
    # Max:     sheet.focus_max  (authoritative; staff / feature grants set it)
    #
    # Focus *spells* live on each magic source as entry["focus_spells"] (slug list).
    # Casting a focus spell will spend 1 FP once the unified cast path exists.
    # Refocus (10 min activity): regain 1, up to max.
    # Daily prep: restore current to max.
    #
    # Usable by any character with a sheet (approved or not).
    # -------------------------------------------------

    FOCUS_POOL_CAP = 3 unless const_defined?(:FOCUS_POOL_CAP)

    def self.focus_current(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      return 0 unless sheet
      sheet.focus_points.to_i
    end

    def self.focus_max(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      return 0 unless sheet
      sheet.focus_max.to_i
    end

    # All focus spell slugs across every magic source: [{ source:, slug: }, ...]
    def self.focus_spell_entries(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      return [] unless sheet
      out = []
      magic_hash(sheet).each do |src, entry|
        next unless entry.is_a?(Hash)
        Array(entry["focus_spells"]).each do |slug|
          s = slug.to_s.strip.downcase
          next if s.empty?
          out << { source: src.to_s, slug: s }
        end
      end
      out
    end

    def self.focus_spell_slugs(char_or_sheet)
      focus_spell_entries(char_or_sheet).map { |e| e[:slug] }.uniq
    end

    def self.has_focus_spells?(char_or_sheet)
      focus_spell_entries(char_or_sheet).any?
    end

    # Clamp max >= 0 and current into 0..max. Call after external mutations.
    def self.ensure_focus_pool!(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      return nil unless sheet

      max = [sheet.focus_max.to_i, 0].max
      cur = sheet.focus_points.to_i
      cur = 0 if cur < 0
      cur = max if cur > max

      updates = {}
      updates[:focus_max] = max if sheet.focus_max.to_i != max
      updates[:focus_points] = cur if sheet.focus_points.to_i != cur
      sheet.update(updates) if updates.any?
      sheet
    end

    # If the character has focus spells but max is still 0, open a pool of 1.
    # Does not auto-grow beyond that — extra capacity is staff/feat driven.
    def self.ensure_focus_pool_from_spells!(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      return nil unless sheet

      if has_focus_spells?(sheet) && sheet.focus_max.to_i <= 0
        sheet.update(focus_max: 1)
        if sheet.focus_points.to_i < 1
          sheet.update(focus_points: 1)
        end
      end
      ensure_focus_pool!(sheet)
    end

    def self.set_focus_max(char_or_sheet, value)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      max = [[value.to_i, 0].max, FOCUS_POOL_CAP].min
      # Staff may intentionally set above soft cap via explicit large values;
      # respect the written value but never negative.
      max = [value.to_i, 0].max
      sheet.update(focus_max: max)
      ensure_focus_pool!(sheet)
      { ok: true, error: nil, max: focus_max(sheet), current: focus_current(sheet) }
    end

    def self.set_focus_current(char_or_sheet, value)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      max = focus_max(sheet)
      cur = value.to_i
      cur = 0 if cur < 0
      cur = max if cur > max
      sheet.update(focus_points: cur)
      { ok: true, error: nil, max: max, current: cur }
    end

    # Increase max by delta (default +1), capped at FOCUS_POOL_CAP unless force.
    def self.increase_focus_max!(char_or_sheet, delta: 1, force: false)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      delta = delta.to_i
      delta = 1 if delta < 1
      new_max = sheet.focus_max.to_i + delta
      new_max = [new_max, FOCUS_POOL_CAP].min unless force
      new_max = 0 if new_max < 0
      sheet.update(focus_max: new_max)
      ensure_focus_pool!(sheet)
      { ok: true, error: nil, max: focus_max(sheet), current: focus_current(sheet) }
    end

    def self.restore_focus_to_max!(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      ensure_focus_pool_from_spells!(sheet)
      max = focus_max(sheet)
      sheet.update(focus_points: max)
      { ok: true, error: nil, max: max, current: max }
    end

    # Refocus activity: regain 1 Focus Point, up to max.
    def self.refocus(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      ensure_focus_pool_from_spells!(sheet)
      max = focus_max(sheet)
      if max <= 0
        return { ok: false, error: "pf2e.focus_no_pool", max: 0, current: 0 }
      end

      before = focus_current(sheet)
      if before >= max
        return { ok: false, error: "pf2e.focus_already_full", max: max, current: before }
      end

      after = before + 1
      sheet.update(focus_points: after)
      { ok: true, error: nil, before: before, after: after, max: max }
    end

    # Spend focus points (casting a focus spell). Default cost 1.
    # Ready for the unified cast path; not exposed as its own player command yet.
    def self.spend_focus(char_or_sheet, amount = 1)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      amount = amount.to_i
      amount = 1 if amount < 1

      max = focus_max(sheet)
      before = focus_current(sheet)
      if before < amount
        return {
          ok: false,
          error: "pf2e.focus_exhausted",
          max: max,
          current: before,
          needed: amount
        }
      end

      after = before - amount
      sheet.update(focus_points: after)
      { ok: true, error: nil, before: before, after: after, max: max, spent: amount }
    end

    def self.format_focus_status(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      return "No PF2e sheet." unless sheet

      ensure_focus_pool_from_spells!(sheet)
      cur = focus_current(sheet)
      max = focus_max(sheet)
      lines = []
      if max <= 0
        lines << "Focus Points: none (no focus pool)"
      else
        lines << "Focus Points: #{cur} / #{max}"
      end

      entries = focus_spell_entries(sheet)
      if entries.empty?
        lines << "  Focus spells: none"
      else
        by_source = entries.group_by { |e| e[:source] }
        by_source.keys.sort.each do |src|
          slugs = by_source[src].map { |e| e[:slug] }.uniq.sort
          lines << "  #{src}: #{slugs.join(', ')}"
        end
      end
      lines.join("\n")
    end

  end
end

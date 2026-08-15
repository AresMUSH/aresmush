module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Focus Points (PF2e Remaster)
    # Current is sheet.focus_points (top-level).
    # Max is sheet.focus_max (top-level). Staff sets max;
    # daily prep restores to max; Refocus regains 1.
    # Usable by any character with a sheet (approved or not).
    # -------------------------------------------------

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

    # Ensure max is non-negative and current is clamped into 0..max.
    # Call after any external mutation of either value.
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

    def self.set_focus_max(char_or_sheet, value)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      max = [value.to_i, 0].max
      sheet.update(focus_max: max)
      ensure_focus_pool!(sheet)
      { ok: true, error: nil, max: max, current: focus_current(sheet) }
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

    # Daily preparation / long rest: restore current to max.
    def self.restore_focus_to_max!(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      max = focus_max(sheet)
      sheet.update(focus_points: max)
      { ok: true, error: nil, max: max, current: max }
    end

    # Refocus activity (10 minutes): regain 1 Focus Point, up to max.
    # Returns { ok:, error:, before:, after:, max: }
    def self.refocus(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

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

    # Spend focus points (e.g. casting a focus spell). Default cost 1.
    def self.spend_focus(char_or_sheet, amount = 1)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      amount = amount.to_i
      amount = 1 if amount < 1

      max = focus_max(sheet)
      before = focus_current(sheet)
      if before < amount
        return { ok: false, error: "pf2e.focus_exhausted", max: max, current: before, needed: amount }
      end

      after = before - amount
      sheet.update(focus_points: after)
      { ok: true, error: nil, before: before, after: after, max: max, spent: amount }
    end

    def self.format_focus_status(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      return "No PF2e sheet." unless sheet

      cur = focus_current(sheet)
      max = focus_max(sheet)
      if max <= 0
        "Focus Points: none (no focus pool)"
      else
        "Focus Points: #{cur} / #{max}"
      end
    end

  end
end

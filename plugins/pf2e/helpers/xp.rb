module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # XP grants (staff, scenes, future automatic sources)
    #
    # Single entry point: grant_xp
    # Does NOT auto-level. When XP crosses the threshold the
    # character uses adv/start → spends → adv/finish.
    #
    # source: short machine tag ("staff", "scene", "plot", …)
    # reason: optional human note ("scene #42 logged", "plot award")
    # -------------------------------------------------

    def self.scene_xp_amount
      n = Global.read_config("pf2e", "scene_xp")
      n.nil? ? 10 : [n.to_i, 0].max
    end

    # Award (or remove) XP on one character/sheet.
    # amount may be negative. XP is floored at 0 (never negative total).
    #
    # Returns:
    #   { ok:, error:, sheet:, char:, before:, after:, amount:,
    #     threshold:, can_level:, source:, reason: }
    def self.grant_xp(char_or_sheet, amount, source: nil, reason: nil)
      amount = amount.to_i
      return { ok: false, error: "pf2e.xp_bad_amount", amount: amount } if amount == 0

      char = nil
      sheet = nil
      if char_or_sheet.is_a?(Pf2eSheet)
        sheet = char_or_sheet
        char = sheet.character if sheet.respond_to?(:character)
      else
        char = char_or_sheet
        sheet = find_or_create_sheet(char)
      end

      return { ok: false, error: "pf2e.no_sheet", char: char, sheet: nil } unless sheet

      before = sheet_xp(sheet)
      after = before + amount
      after = 0 if after < 0

      sheet.update(xp: after)

      threshold = xp_to_level
      {
        ok: true,
        error: nil,
        sheet: sheet,
        char: char,
        before: before,
        after: after,
        amount: after - before, # actual delta after floor
        requested: amount,
        threshold: threshold,
        can_level: after >= threshold && !advancing?(sheet),
        source: source.to_s,
        reason: reason.to_s
      }
    end

    # Batch grant — same amount to each character (e.g. scene participants).
    # Skips nils; continues on individual failures.
    #
    # Returns:
    #   { ok: true, results: [...], granted: [char names], failed: [...] }
    def self.grant_xp_to_many(chars, amount, source: nil, reason: nil)
      results = []
      granted = []
      failed = []

      Array(chars).compact.each do |c|
        r = grant_xp(c, amount, source: source, reason: reason)
        results << r
        if r[:ok]
          name = r[:char] ? r[:char].name : "?"
          granted << name
        else
          failed << { char: c, error: r[:error] }
        end
      end

      {
        ok: true,
        results: results,
        granted: granted,
        failed: failed,
        amount: amount.to_i,
        source: source.to_s,
        reason: reason.to_s
      }
    end

    # Convenience for logged scenes. Amount from pf2e.yml scene_xp (default 10).
    # Pass scene participants (Character objects). Idempotency is the caller's job
    # (e.g. only fire once when the scene is shared/logged).
    def self.grant_scene_xp(participants, scene_id: nil, amount: nil)
      amt = amount.nil? ? scene_xp_amount : amount.to_i
      return { ok: false, error: "pf2e.xp_bad_amount", amount: amt } if amt == 0

      reason = scene_id ? "scene #{scene_id}" : "scene"
      grant_xp_to_many(participants, amt, source: "scene", reason: reason)
    end

  end
end

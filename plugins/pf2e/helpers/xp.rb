module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # XP grants (staff, scenes, future automatic sources)
    #
    # Single entry point: grant_xp
    # Does NOT auto-level. When XP crosses the threshold the
    # character uses adv/start → spends → adv/finish.
    #
    # Crossing notify: only when before < threshold and after >= threshold
    # (and not already advancing). One message, not on every later grant.
    #
    # Scene awards are idempotent per sheet via xp_awarded_scenes.
    # -------------------------------------------------

    def self.scene_xp_amount
      n = Global.read_config("pf2e", "scene_xp")
      n.nil? ? 10 : [n.to_i, 0].max
    end

    def self.scene_xp_enabled?
      val = Global.read_config("pf2e", "scene_xp_enabled")
      return true if val.nil?
      val == true || val.to_s == "true" || val.to_s == "1"
    end

    def self.scene_xp_already_awarded?(sheet, scene_id)
      return false unless sheet && scene_id
      list = sheet.respond_to?(:xp_awarded_scenes) ? Array(sheet.xp_awarded_scenes) : []
      list.map(&:to_s).include?(scene_id.to_s)
    end

    def self.mark_scene_xp_awarded!(sheet, scene_id)
      return unless sheet && scene_id
      list = Array(sheet.xp_awarded_scenes).map(&:to_s)
      sid = scene_id.to_s
      return list if list.include?(sid)
      list << sid
      sheet.update(xp_awarded_scenes: list)
      list
    end

    def self.notify_ready_to_level(char)
      return unless char && defined?(Login)
      begin
        Login.emit_ooc_if_logged_in(char, t('pf2e.xp_ready_to_level'))
      rescue => e
        Global.logger.warn "Pf2e ready-to-level notify failed: #{e.message}"
      end
    end

    # Award (or remove) XP on one character/sheet.
    # amount may be negative. XP is floored at 0.
    #
    # notify: if true (default), send a one-time OOC when the award *crosses*
    # the level threshold. Already-over-threshold grants stay silent.
    def self.grant_xp(char_or_sheet, amount, source: nil, reason: nil, notify: true)
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

      threshold = xp_to_level
      before = sheet_xp(sheet)
      after = before + amount
      after = 0 if after < 0

      sheet.update(xp: after)

      can_level = after >= threshold && !advancing?(sheet)
      # One notify only: must newly cross into ready-to-level territory.
      crossed = notify && can_level && before < threshold && after >= threshold
      notify_ready_to_level(char) if crossed

      {
        ok: true,
        error: nil,
        sheet: sheet,
        char: char,
        before: before,
        after: after,
        amount: after - before,
        requested: amount,
        threshold: threshold,
        can_level: can_level,
        crossed_threshold: crossed,
        source: source.to_s,
        reason: reason.to_s
      }
    end

    def self.grant_xp_to_many(chars, amount, source: nil, reason: nil, notify: true)
      results = []
      granted = []
      failed = []
      skipped = []

      Array(chars).compact.each do |c|
        r = grant_xp(c, amount, source: source, reason: reason, notify: notify)
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
        skipped: skipped,
        amount: amount.to_i,
        source: source.to_s,
        reason: reason.to_s
      }
    end

    # Award scene XP to participants with per-character idempotency.
    # Ready-to-level notify is handled inside grant_xp (threshold cross only).
    def self.grant_scene_xp(participants, scene_id:, amount: nil, force: false, notify: true)
      return { ok: false, error: "pf2e.xp_no_scene_id" } if scene_id.nil? || scene_id.to_s.empty?

      amt = amount.nil? ? scene_xp_amount : amount.to_i
      return { ok: false, error: "pf2e.xp_bad_amount", amount: amt } if amt == 0

      reason = "scene #{scene_id}"
      results = []
      granted = []
      skipped = []
      failed = []

      Array(participants).compact.uniq.each do |char|
        sheet = find_or_create_sheet(char)
        unless sheet
          failed << { char: char, error: "pf2e.no_sheet" }
          next
        end

        if !force && scene_xp_already_awarded?(sheet, scene_id)
          skipped << (char.respond_to?(:name) ? char.name : "?")
          results << {
            ok: true,
            skipped: true,
            char: char,
            sheet: sheet,
            reason: "already awarded for scene #{scene_id}"
          }
          next
        end

        r = grant_xp(sheet, amt, source: "scene", reason: reason, notify: notify)
        results << r
        if r[:ok]
          mark_scene_xp_awarded!(sheet, scene_id)
          name = char.respond_to?(:name) ? char.name : "?"
          granted << name

          # Scene-specific award line only (ready-to-level comes from grant_xp).
          if notify
            begin
              msg = t('pf2e.scene_xp_awarded',
                     :amount => r[:amount],
                     :xp => r[:after],
                     :need => r[:threshold],
                     :scene => scene_id)
              Login.emit_ooc_if_logged_in(char, msg) if defined?(Login)
            rescue => e
              Global.logger.warn "Pf2e scene XP notify failed for #{name}: #{e.message}"
            end
          end
        else
          failed << { char: char, error: r[:error] }
        end
      end

      {
        ok: true,
        results: results,
        granted: granted,
        skipped: skipped,
        failed: failed,
        amount: amt,
        scene_id: scene_id.to_s,
        source: "scene",
        reason: reason
      }
    end

    def self.award_xp_for_shared_scene(scene)
      return { ok: false, error: "pf2e.xp_scene_missing" } unless scene
      return { ok: false, error: "pf2e.xp_scene_disabled" } unless scene_xp_enabled?

      participants = scene.respond_to?(:participants) ? scene.participants.to_a : []
      grant_scene_xp(participants, scene_id: scene.id)
    end

  end
end

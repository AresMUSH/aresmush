module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Advancement packages + XP-gated level-up flow
    #
    # Flow:
    #   adv/start   — require XP >= xp_to_level, not already advancing
    #                 level += 1, apply autos, queue pending, advancing=true
    #   adv/skill, adv/boost, adv/feat — only while advancing
    #   adv/finish  — require advancing; skill_increase + ability_boost spent;
    #                 xp -= xp_to_level; advancing=false
    # -------------------------------------------------

    UNIVERSAL_SKILL_INCREASE_FROM = 2
    UNIVERSAL_ABILITY_BOOST_LEVELS = {
      5 => 4, 10 => 4, 15 => 4, 20 => 4
    }.freeze

    SKILL_RANK_MIN_LEVEL = {
      "E" => 3,
      "M" => 7,
      "L" => 15
    }.freeze

    def self.xp_to_level
      n = Global.read_config("pf2e", "xp_to_level")
      n = 1000 if n.nil?
      [n.to_i, 1].max
    end

    def self.sheet_xp(sheet)
      return 0 unless sheet
      sheet.xp.to_i
    end

    def self.advancing?(sheet)
      return false unless sheet
      val = sheet.advancing
      val == true || val.to_s == "true" || val.to_s == "1"
    end

    def self.advancement_package(class_entry, level)
      return {} unless class_entry.is_a?(Hash)
      adv = class_entry["advancement"]
      if adv.is_a?(Hash)
        pkg = adv[level] || adv[level.to_s] || adv[level.to_i]
        return pkg.is_a?(Hash) ? pkg : {}
      end

      legacy = (class_entry["features_by_level"] || {})[level] ||
               (class_entry["features_by_level"] || {})[level.to_s]
      return {} unless legacy

      pkg = { "features" => [] }
      Array(legacy).each do |token|
        slot = slot_type_for_marker(token)
        if slot
          key = "#{slot}_feat"
          pkg[key] = pkg[key].to_i + 1
        else
          pkg["features"] << token.to_s.strip.downcase
        end
      end
      pkg
    end

    def self.universal_grants_at(level)
      lvl = level.to_i
      {
        "skill_increase" => (lvl >= UNIVERSAL_SKILL_INCREASE_FROM ? 1 : 0),
        "ability_boost" => UNIVERSAL_ABILITY_BOOST_LEVELS[lvl].to_i
      }
    end

    def self.level_package(char_or_sheet, level)
      sheet = sheet_for(char_or_sheet)
      entry = class_entry_for_sheet(sheet)
      class_pkg = advancement_package(entry, level)
      uni = universal_grants_at(level)

      {
        "level" => level.to_i,
        "features" => Array(class_pkg["features"]).map { |s| s.to_s.strip.downcase }.reject(&:empty?),
        "class_feat" => class_pkg["class_feat"].to_i,
        "skill_feat" => class_pkg["skill_feat"].to_i,
        "general_feat" => class_pkg["general_feat"].to_i,
        "ancestry_feat" => class_pkg["ancestry_feat"].to_i,
        "skill_increase" => class_pkg["skill_increase"].to_i + uni["skill_increase"],
        "ability_boost" => class_pkg["ability_boost"].to_i + uni["ability_boost"],
        "proficiency" => class_pkg["proficiency"].is_a?(Hash) ? class_pkg["proficiency"] : {},
        "choice" => class_pkg["choice"],
        "spellcasting" => class_pkg["spellcasting"].is_a?(Hash) ? class_pkg["spellcasting"] : {},
        "notes" => class_pkg["notes"].to_s
      }
    end

    def self.empty_pending
      {
        "skill_increase" => 0,
        "ability_boost" => 0,
        "class_feat" => 0,
        "skill_feat" => 0,
        "general_feat" => 0,
        "ancestry_feat" => 0
      }
    end

    def self.sheet_pending(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      return empty_pending unless sheet
      raw = sheet.respond_to?(:pending_advancement) ? sheet.pending_advancement : nil
      base = empty_pending
      return base unless raw.is_a?(Hash)
      base.keys.each { |k| base[k] = raw[k].to_i }
      base
    end

    def self.set_pending(sheet, hash)
      merged = empty_pending
      hash.each { |k, v| merged[k.to_s] = v.to_i if merged.key?(k.to_s) }
      sheet.update(pending_advancement: merged)
      merged
    end

    def self.add_pending!(sheet, deltas)
      cur = sheet_pending(sheet)
      deltas.each { |k, v| cur[k.to_s] = cur[k.to_s].to_i + v.to_i if cur.key?(k.to_s) }
      set_pending(sheet, cur)
    end

    def self.pending_spend!(sheet, key, n = 1)
      cur = sheet_pending(sheet)
      k = key.to_s
      return false unless cur.key?(k)
      return false if cur[k] < n
      cur[k] -= n
      set_pending(sheet, cur)
      true
    end

    def self.skill_increase_rank_ok?(char_level, new_rank)
      rank = new_rank.to_s.strip.upcase
      return true if rank == "T"
      min = SKILL_RANK_MIN_LEVEL[rank]
      return false unless min
      char_level.to_i >= min
    end

    def self.next_skill_rank(current)
      case current.to_s.strip.upcase
      when "U", "" then "T"
      when "T" then "E"
      when "E" then "M"
      when "M" then "L"
      else nil
      end
    end

    def self.teml_rank_value(rank)
      { "U" => 0, "T" => 1, "E" => 2, "M" => 3, "L" => 4 }[rank.to_s.strip.upcase] || 0
    end

    def self.merge_proficiency_overlay!(sheet, proficiency_hash)
      return unless sheet && proficiency_hash.is_a?(Hash)
      overlay = (sheet.proficiencies || {}).dup

      %w[perception class_dc fortitude reflex will].each do |k|
        next unless proficiency_hash.key?(k) || proficiency_hash.key?(k.to_sym)
        rank = (proficiency_hash[k] || proficiency_hash[k.to_sym]).to_s.strip.upcase
        next if rank.empty?
        if k == "perception" || %w[fortitude reflex will].include?(k)
          set_save_rank(sheet, k, rank) if teml_rank_value(rank) > teml_rank_value(save_rank(sheet, k))
        else
          cur = overlay[k].to_s.strip.upcase
          overlay[k] = rank if teml_rank_value(rank) > teml_rank_value(cur)
        end
      end

      atk = proficiency_hash["attacks"] || proficiency_hash[:attacks]
      if atk.is_a?(Hash)
        overlay["attacks"] ||= {}
        atk.each do |cat, rank|
          r = rank.to_s.strip.upcase
          cur = overlay["attacks"][cat.to_s].to_s.strip.upcase
          overlay["attacks"][cat.to_s] = r if teml_rank_value(r) > teml_rank_value(cur)
        end
      end

      defn = proficiency_hash["defenses"] || proficiency_hash[:defenses]
      if defn.is_a?(Hash)
        overlay["defenses"] ||= {}
        defn.each do |cat, rank|
          r = rank.to_s.strip.upcase
          cur = overlay["defenses"][cat.to_s].to_s.strip.upcase
          overlay["defenses"][cat.to_s] = r if teml_rank_value(r) > teml_rank_value(cur)
        end
      end

      sk = proficiency_hash["skills"] || proficiency_hash[:skills]
      if sk.is_a?(Hash)
        sk.each do |skill, rank|
          r = rank.to_s.strip.upcase
          next if r.empty?
          set_skill_rank(sheet, skill, r) if teml_rank_value(r) > teml_rank_value(skill_rank(sheet, skill))
        end
      end

      sheet.update(proficiencies: overlay)
      overlay
    end

    def self.adv_require_identity(sheet)
      return { ok: false, error: "pf2e.cg_identity_not_locked", sheet: sheet } unless cg_identity_locked?(sheet)
      nil
    end

    def self.adv_require_advancing(sheet)
      return { ok: false, error: "pf2e.adv_not_advancing", sheet: sheet } unless advancing?(sheet)
      nil
    end

    def self.adv_require_not_advancing(sheet)
      return { ok: false, error: "pf2e.adv_already_advancing", sheet: sheet } if advancing?(sheet)
      nil
    end

    def self.adv_status(char)
      result = cg_ensure_sheet(char)
      return result unless result[:ok]
      sheet = result[:sheet]
      threshold = xp_to_level
      xp = sheet_xp(sheet)
      {
        ok: true,
        error: nil,
        sheet: sheet,
        level: sheet.level.to_i,
        xp: xp,
        xp_to_level: threshold,
        xp_needed: [threshold - xp, 0].max,
        can_start: xp >= threshold && !advancing?(sheet) && cg_identity_locked?(sheet),
        advancing: advancing?(sheet),
        pending: sheet_pending(sheet),
        feat_slots: feat_slots_status(sheet)
      }
    end

    # Begin a level-up. Does NOT subtract XP (that happens on finish).
    def self.adv_start(char)
      result = cg_ensure_sheet(char)
      return result unless result[:ok]
      sheet = result[:sheet]

      locked = adv_require_identity(sheet)
      return locked if locked
      busy = adv_require_not_advancing(sheet)
      return busy if busy

      threshold = xp_to_level
      if sheet_xp(sheet) < threshold
        return {
          ok: false,
          error: "pf2e.adv_insufficient_xp",
          sheet: sheet,
          xp: sheet_xp(sheet),
          xp_to_level: threshold
        }
      end

      old_level = [sheet.level.to_i, 1].max
      if old_level >= 20
        return { ok: false, error: "pf2e.adv_max_level", sheet: sheet }
      end

      new_level = old_level + 1
      pkg = level_package(sheet, new_level)

      sheet.update(level: new_level, advancing: true)

      cg_apply_granted_features(sheet)
      merge_proficiency_overlay!(sheet, pkg["proficiency"])
      cg_recalc_hp(sheet)

      pending = empty_pending
      pending["skill_increase"] = pkg["skill_increase"].to_i
      pending["ability_boost"] = pkg["ability_boost"].to_i
      pending["class_feat"] = pkg["class_feat"].to_i
      pending["skill_feat"] = pkg["skill_feat"].to_i
      pending["general_feat"] = pkg["general_feat"].to_i
      pending["ancestry_feat"] = pkg["ancestry_feat"].to_i
      set_pending(sheet, pending)

      # Stash structured choices for this level if any
      if pkg["choice"]
        picks = (sheet.advancement_picks || {}).dup
        picks["_pending_choice"] = pkg["choice"]
        sheet.update(advancement_picks: picks)
      end

      {
        ok: true,
        error: nil,
        sheet: sheet,
        level: new_level,
        package: pkg,
        pending: sheet_pending(sheet),
        features: sheet_features(sheet),
        xp: sheet_xp(sheet),
        xp_to_level: threshold
      }
    end

    def self.adv_finish(char)
      result = cg_ensure_sheet(char)
      return result unless result[:ok]
      sheet = result[:sheet]

      need = adv_require_advancing(sheet)
      return need if need

      pending = sheet_pending(sheet)
      if pending["skill_increase"].to_i > 0
        return { ok: false, error: "pf2e.adv_pending_skill", sheet: sheet, pending: pending }
      end
      if pending["ability_boost"].to_i > 0
        return { ok: false, error: "pf2e.adv_pending_boost", sheet: sheet, pending: pending }
      end

      threshold = xp_to_level
      xp = sheet_xp(sheet)
      if xp < threshold
        # Should not happen if start gated correctly; still safe-guard.
        return {
          ok: false,
          error: "pf2e.adv_insufficient_xp",
          sheet: sheet,
          xp: xp,
          xp_to_level: threshold
        }
      end

      new_xp = xp - threshold
      sheet.update(
        xp: new_xp,
        advancing: false,
        pending_advancement: empty_pending
      )

      picks = (sheet.advancement_picks || {}).dup
      picks.delete("_pending_choice")
      sheet.update(advancement_picks: picks)

      {
        ok: true,
        error: nil,
        sheet: sheet,
        level: sheet.level.to_i,
        xp: new_xp,
        xp_to_level: threshold,
        subtracted: threshold
      }
    end

    def self.adv_skill_increase(char, skill_slug)
      result = cg_ensure_sheet(char)
      return result unless result[:ok]
      sheet = result[:sheet]

      need = adv_require_advancing(sheet)
      return need if need

      pending = sheet_pending(sheet)
      if pending["skill_increase"].to_i <= 0
        return { ok: false, error: "pf2e.adv_no_skill_increase", sheet: sheet }
      end

      key = skill_slug.to_s.strip.downcase
      return { ok: false, error: "pf2e.cg_skill_usage", sheet: sheet } if key.empty?

      data = read_data("skills") || {}
      unless data.key?(key) || key == "lore" || key.end_with?("_lore")
        return { ok: false, error: "pf2e.cg_unknown_skill", sheet: sheet }
      end

      current = skill_rank(sheet, key)
      nxt = next_skill_rank(current)
      return { ok: false, error: "pf2e.adv_skill_max", sheet: sheet } if nxt.nil?

      unless skill_increase_rank_ok?(sheet.level, nxt)
        return {
          ok: false,
          error: "pf2e.adv_skill_rank_level",
          sheet: sheet,
          rank: nxt,
          level: sheet.level.to_i
        }
      end

      set_skill_rank(sheet, key, nxt)
      pending_spend!(sheet, "skill_increase", 1)

      {
        ok: true,
        error: nil,
        sheet: sheet,
        skill: key,
        from: current,
        to: nxt,
        pending: sheet_pending(sheet)
      }
    end

    # Ability boosts from leveling (source key level_5, level_10, …).
    # All boosts for this level must be assigned in one command (count = pending).
    def self.adv_ability_boosts(char, abilities)
      result = cg_ensure_sheet(char)
      return result unless result[:ok]
      sheet = result[:sheet]

      need = adv_require_advancing(sheet)
      return need if need

      pending = sheet_pending(sheet)
      needed = pending["ability_boost"].to_i
      if needed <= 0
        return { ok: false, error: "pf2e.adv_no_ability_boost", sheet: sheet }
      end

      keys = Array(abilities).map { |a| ability_key(a) }
      if keys.any?(&:nil?)
        return { ok: false, error: "pf2e.cg_unknown_ability", sheet: sheet }
      end
      if keys.size != keys.uniq.size
        return { ok: false, error: "pf2e.cg_duplicate_boost", sheet: sheet }
      end
      if keys.size != needed
        return { ok: false, error: "pf2e.adv_boost_count", sheet: sheet, needed: needed }
      end

      source = "level_#{sheet.level.to_i}"
      stored = (sheet.ability_boosts || {}).dup
      stored[source] = keys
      sheet.update(ability_boosts: stored)
      cg_recalc_abilities(sheet)
      cg_recalc_hp(sheet)

      pending["ability_boost"] = 0
      set_pending(sheet, pending)

      {
        ok: true,
        error: nil,
        sheet: sheet,
        source: source,
        boosts: keys,
        pending: sheet_pending(sheet)
      }
    end

    # Take a feat while advancing (approved chars OK). Slot rules unchanged.
    def self.adv_take_feat(char, slug, slot_type: nil)
      result = cg_ensure_sheet(char)
      return result unless result[:ok]
      sheet = result[:sheet]

      need = adv_require_advancing(sheet)
      return need if need

      key = slug.to_s.strip.downcase
      entry = feat_entry(key)
      return { ok: false, error: "pf2e.cg_unknown_feat", sheet: sheet } unless entry.is_a?(Hash)

      owned = Array(sheet.feats).map { |f| f.to_s.strip.downcase }
      return { ok: false, error: "pf2e.cg_feat_owned", sheet: sheet } if owned.include?(key)

      limit = dedication_limit_block(sheet, key, staff: false)
      return limit if limit

      check = feat_prereqs_met?(sheet, key)
      unless check[:ok]
        return { ok: false, error: "pf2e.cg_feat_prereq", sheet: sheet, failures: check[:failures] }
      end

      open_slots = feat_available_slots_for(sheet, key)
      if open_slots.empty?
        return { ok: false, error: "pf2e.cg_feat_no_slot", sheet: sheet }
      end

      chosen = slot_type ? slot_type.to_s.strip.downcase : nil
      if chosen
        unless feat_slot_type?(chosen)
          return { ok: false, error: "pf2e.cg_feat_bad_slot", sheet: sheet }
        end
        unless open_slots.include?(chosen)
          return {
            ok: false,
            error: "pf2e.cg_feat_slot_unavailable",
            sheet: sheet,
            open_slots: open_slots
          }
        end
      else
        if open_slots.size > 1
          return {
            ok: false,
            error: "pf2e.cg_feat_slot_required",
            sheet: sheet,
            open_slots: open_slots
          }
        end
        chosen = open_slots.first
      end

      owned << key
      map = (sheet.feat_slot_map || {}).dup
      map[key] = chosen
      sheet.update(feats: owned, feat_slot_map: map)
      archetype_on_dedication_taken(sheet, key)

      # Decrement guidance counters when present
      pending = sheet_pending(sheet)
      case chosen
      when "class" then pending["class_feat"] = [pending["class_feat"] - 1, 0].max
      when "skill" then pending["skill_feat"] = [pending["skill_feat"] - 1, 0].max
      when "general" then pending["general_feat"] = [pending["general_feat"] - 1, 0].max
      when "ancestry" then pending["ancestry_feat"] = [pending["ancestry_feat"] - 1, 0].max
      end
      set_pending(sheet, pending)

      {
        ok: true,
        error: nil,
        sheet: sheet,
        feat: key,
        name: entry["name"] || key,
        slot: chosen,
        pending: sheet_pending(sheet),
        remaining: feat_slots_remaining(sheet)
      }
    end

  end
end

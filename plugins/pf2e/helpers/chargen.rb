module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Chargen helpers
    # Pure logic for sheet setup. Commands and (later) web
    # both call these; they return a result hash:
    #   { ok: true/false, error: "locale key or message", sheet: Pf2eSheet }
    # -------------------------------------------------

    CG_BOOST_SOURCES = %w[ancestry heritage background].freeze

    def self.cg_ensure_sheet(char)
      return { ok: false, error: "pf2e.character_not_found", sheet: nil } if char.nil?

      sheet = find_or_create_sheet(char)
      return { ok: false, error: "pf2e.no_sheet", sheet: nil } unless sheet

      { ok: true, error: nil, sheet: sheet }
    end

    def self.cg_ancestry_entry(slug)
      return nil if slug.nil? || slug.to_s.strip.empty?
      read_data("ancestries", slug.to_s.strip.downcase)
    end

    def self.cg_heritage_entry(slug)
      return nil if slug.nil? || slug.to_s.strip.empty?
      read_data("heritages", slug.to_s.strip.downcase)
    end

    def self.cg_background_entry(slug)
      return nil if slug.nil? || slug.to_s.strip.empty?
      read_data("backgrounds", slug.to_s.strip.downcase)
    end

    def self.cg_class_entry(slug)
      return nil if slug.nil? || slug.to_s.strip.empty?
      read_data("charclasses", slug.to_s.strip.downcase)
    end

    def self.cg_apply_boost(score)
      s = score.to_i
      s >= 18 ? s + 1 : s + 2
    end

    def self.cg_apply_flaw(score)
      score.to_i - 2
    end

    def self.cg_recalc_abilities(sheet)
      return unless sheet

      scores = {}
      ABILITY_KEYS.each { |k| scores[k] = 10 }

      anc = cg_ancestry_entry(sheet.ancestry)
      if anc.is_a?(Hash)
        Array((anc["boosts"] || {})["fixed"]).each do |raw|
          k = ability_key(raw)
          scores[k] = cg_apply_boost(scores[k]) if k
        end
        Array((anc["flaws"] || {})["fixed"]).each do |raw|
          k = ability_key(raw)
          scores[k] = cg_apply_flaw(scores[k]) if k
        end
      end

      stored = sheet.ability_boosts || {}
      CG_BOOST_SOURCES.each do |source|
        Array(stored[source] || stored[source.to_sym]).each do |raw|
          k = ability_key(raw)
          scores[k] = cg_apply_boost(scores[k]) if k
        end
      end

      cc = sheet.charclass || {}
      key_abil = ability_key(cc["key_ability"] || cc[:key_ability])
      scores[key_abil] = cg_apply_boost(scores[key_abil]) if key_abil

      abilities = {}
      ABILITY_KEYS.each do |k|
        base = (sheet.abilities[k] && sheet.abilities[k][0]) ? sheet.abilities[k][0].to_i : 10
        abilities[k] = [base, scores[k]]
      end
      sheet.update(abilities: abilities)
      scores
    end

    def self.cg_free_boost_requirements(sheet, source)
      source = source.to_s.strip.downcase
      case source
      when "ancestry"
        entry = cg_ancestry_entry(sheet.ancestry)
        return [0, nil] unless entry.is_a?(Hash)
        boosts = entry["boosts"] || {}
        [boosts["free"].to_i, boosts["options"]]
      when "heritage"
        entry = cg_heritage_entry(sheet.heritage)
        return [0, nil] unless entry.is_a?(Hash)
        boosts = entry["boosts"] || {}
        [boosts["free"].to_i, boosts["options"]]
      when "background"
        entry = cg_background_entry(sheet.background)
        return [0, nil] unless entry.is_a?(Hash)
        boosts = entry["boosts"] || {}
        [boosts["free"].to_i, boosts["options"]]
      else
        [0, nil]
      end
    end

    def self.cg_set_boosts(char, source, abilities)
      result = cg_ensure_sheet(char)
      return result unless result[:ok]

      sheet = result[:sheet]
      source = source.to_s.strip.downcase
      unless CG_BOOST_SOURCES.include?(source)
        return { ok: false, error: "pf2e.cg_bad_boost_source", sheet: sheet }
      end

      case source
      when "ancestry"
        return { ok: false, error: "pf2e.cg_need_ancestry", sheet: sheet } if sheet.ancestry.blank?
      when "heritage"
        return { ok: false, error: "pf2e.cg_need_heritage", sheet: sheet } if sheet.heritage.blank?
      when "background"
        return { ok: false, error: "pf2e.cg_need_background", sheet: sheet } if sheet.background.blank?
      end

      needed, options = cg_free_boost_requirements(sheet, source)
      if needed <= 0
        return { ok: false, error: "pf2e.cg_no_free_boosts", sheet: sheet }
      end

      keys = Array(abilities).map { |a| ability_key(a) }
      if keys.any?(&:nil?)
        return { ok: false, error: "pf2e.cg_unknown_ability", sheet: sheet }
      end

      if keys.size != keys.uniq.size
        return { ok: false, error: "pf2e.cg_duplicate_boost", sheet: sheet }
      end

      if keys.size != needed
        return { ok: false, error: "pf2e.cg_boost_count", sheet: sheet }
      end

      if options.is_a?(Array) && !options.empty?
        allowed = options.map { |o| ability_key(o) || o.to_s }
        unless keys.all? { |k| allowed.include?(k) }
          return { ok: false, error: "pf2e.cg_boost_not_in_options", sheet: sheet }
        end
      end

      if source == "ancestry"
        anc = cg_ancestry_entry(sheet.ancestry)
        fixed = Array((anc && anc["boosts"] || {})["fixed"]).map { |a| ability_key(a) }.compact
        if keys.any? { |k| fixed.include?(k) }
          return { ok: false, error: "pf2e.cg_boost_overlaps_fixed", sheet: sheet }
        end
      end

      stored = (sheet.ability_boosts || {}).dup
      stored[source] = keys
      sheet.update(ability_boosts: stored)
      cg_recalc_abilities(sheet)
      cg_recalc_hp(sheet)

      { ok: true, error: nil, sheet: sheet, boosts: keys }
    end

    def self.cg_forced_skills(sheet)
      forced = []

      bg = cg_background_entry(sheet.background)
      if bg.is_a?(Hash)
        Array(bg["skills"]).each { |s| forced << s.to_s.strip.downcase }
      end

      # Resolved skill_choices (Guard lore pick, Nomad terrain lore, etc.)
      Array(sheet.background_skill_picks).each do |s|
        forced << s.to_s.strip.downcase
      end

      cc = sheet.charclass || {}
      class_entry = cg_class_entry(cc["slug"] || cc[:slug])
      if class_entry.is_a?(Hash)
        additional = ((class_entry["skills"] || {})["additional"]) || []
        Array(additional).each { |s| forced << s.to_s.strip.downcase }
      end

      forced.reject(&:empty?).uniq
    end

    def self.cg_skill_picks_total(sheet)
      cc = sheet.charclass || {}
      class_entry = cg_class_entry(cc["slug"] || cc[:slug])
      return 0 unless class_entry.is_a?(Hash)

      trained_count = ((class_entry["skills"] || {})["trained_count"] || 0).to_i
      int_mod = ability_mod(sheet, "int")
      [trained_count + int_mod, 0].max
    end

    def self.cg_skill_picks_used(sheet)
      forced = cg_forced_skills(sheet)
      trained = (sheet.skills || {}).keys.map { |k| k.to_s.strip.downcase }
      trained = trained.select { |k| skill_rank(sheet, k) != "U" }
      (trained - forced).size
    end

    def self.cg_skill_picks_remaining(sheet)
      [cg_skill_picks_total(sheet) - cg_skill_picks_used(sheet), 0].max
    end

    def self.cg_skill_status(char)
      result = cg_ensure_sheet(char)
      return result unless result[:ok]

      sheet = result[:sheet]
      if sheet.charclass.blank? || (sheet.charclass["slug"].to_s.empty? && sheet.charclass[:slug].to_s.empty?)
        return { ok: false, error: "pf2e.cg_need_class", sheet: sheet }
      end

      trained = (sheet.skills || {}).keys.map(&:to_s).sort
      {
        ok: true,
        error: nil,
        sheet: sheet,
        total: cg_skill_picks_total(sheet),
        used: cg_skill_picks_used(sheet),
        remaining: cg_skill_picks_remaining(sheet),
        forced: cg_forced_skills(sheet),
        trained: trained
      }
    end

    def self.cg_train_skills(char, skill_slugs)
      result = cg_ensure_sheet(char)
      return result unless result[:ok]

      sheet = result[:sheet]
      if sheet.charclass.blank? || (sheet.charclass["slug"].to_s.empty? && sheet.charclass[:slug].to_s.empty?)
        return { ok: false, error: "pf2e.cg_need_class", sheet: sheet }
      end

      slugs = Array(skill_slugs).map { |s| s.to_s.strip.downcase }.reject(&:empty?)
      return { ok: false, error: "pf2e.cg_skill_usage", sheet: sheet } if slugs.empty?

      if slugs.size != slugs.uniq.size
        return { ok: false, error: "pf2e.cg_skill_duplicate", sheet: sheet }
      end

      data = read_data("skills") || {}
      slugs.each do |sk|
        unless data.key?(sk)
          return { ok: false, error: "pf2e.cg_unknown_skill", sheet: sheet }
        end
        if skill_rank(sheet, sk) != "U"
          return { ok: false, error: "pf2e.cg_skill_already_trained", sheet: sheet }
        end
      end

      remaining = cg_skill_picks_remaining(sheet)
      if slugs.size > remaining
        return { ok: false, error: "pf2e.cg_skill_no_picks", sheet: sheet }
      end

      slugs.each { |sk| set_skill_rank(sheet, sk, "T") }

      {
        ok: true,
        error: nil,
        sheet: sheet,
        trained: slugs,
        remaining: cg_skill_picks_remaining(sheet)
      }
    end

    def self.cg_set_ancestry(char, slug)
      result = cg_ensure_sheet(char)
      return result unless result[:ok]

      key = slug.to_s.strip.downcase
      entry = cg_ancestry_entry(key)
      unless entry.is_a?(Hash)
        return { ok: false, error: "pf2e.cg_unknown_ancestry", sheet: result[:sheet] }
      end

      sheet = result[:sheet]
      updates = { ancestry: key }

      allowed = Array(entry["heritages"]).map { |h| h.to_s }
      if sheet.heritage && !allowed.include?(sheet.heritage.to_s)
        updates[:heritage] = nil
      end

      if entry["speed"]
        updates[:speed] = entry["speed"].to_i
      end

      stored = (sheet.ability_boosts || {}).dup
      stored.delete("ancestry")
      stored.delete("heritage") if updates.key?(:heritage)
      updates[:ability_boosts] = stored

      sheet.update(updates)
      cg_recalc_abilities(sheet)
      cg_recalc_hp(sheet)

      { ok: true, error: nil, sheet: sheet, entry: entry }
    end

    def self.cg_set_heritage(char, slug)
      result = cg_ensure_sheet(char)
      return result unless result[:ok]

      sheet = result[:sheet]
      if sheet.ancestry.blank?
        return { ok: false, error: "pf2e.cg_need_ancestry", sheet: sheet }
      end

      key = slug.to_s.strip.downcase
      entry = cg_heritage_entry(key)
      unless entry.is_a?(Hash)
        return { ok: false, error: "pf2e.cg_unknown_heritage", sheet: sheet }
      end

      anc = cg_ancestry_entry(sheet.ancestry)
      allowed = Array(anc && anc["heritages"]).map { |h| h.to_s }
      unless allowed.include?(key)
        return { ok: false, error: "pf2e.cg_heritage_not_for_ancestry", sheet: sheet }
      end

      parent = entry["ancestry"].to_s
      if !parent.empty? && parent != sheet.ancestry.to_s
        return { ok: false, error: "pf2e.cg_heritage_not_for_ancestry", sheet: sheet }
      end

      stored = (sheet.ability_boosts || {}).dup
      stored.delete("heritage")
      sheet.update(heritage: key, ability_boosts: stored)
      cg_recalc_abilities(sheet)
      cg_recalc_hp(sheet)

      { ok: true, error: nil, sheet: sheet, entry: entry }
    end

    def self.cg_set_background(char, slug)
      result = cg_ensure_sheet(char)
      return result unless result[:ok]

      key = slug.to_s.strip.downcase
      entry = cg_background_entry(key)
      unless entry.is_a?(Hash)
        return { ok: false, error: "pf2e.cg_unknown_background", sheet: result[:sheet] }
      end

      sheet = result[:sheet]
      stored = (sheet.ability_boosts || {}).dup
      stored.delete("background")
      # Fixed skills only; skill_choices resolved via cg/bgskill
      sheet.update(
        background: key,
        ability_boosts: stored,
        background_skill_picks: []
      )

      Array(entry["skills"]).each do |sk|
        sk_key = sk.to_s.strip.downcase
        next if sk_key.empty?
        current = skill_rank(sheet, sk_key)
        set_skill_rank(sheet, sk_key, "T") if current == "U"
      end

      feat = entry["feat"].to_s.strip.downcase
      if !feat.empty?
        feats = Array(sheet.feats).map { |f| f.to_s }
        unless feats.include?(feat)
          feats << feat
          sheet.update(feats: feats)
        end
      end

      cg_recalc_abilities(sheet)
      cg_recalc_hp(sheet)

      { ok: true, error: nil, sheet: sheet, entry: entry }
    end

    def self.cg_set_class(char, slug, key_ability: nil)
      result = cg_ensure_sheet(char)
      return result unless result[:ok]

      key = slug.to_s.strip.downcase
      entry = cg_class_entry(key)
      unless entry.is_a?(Hash)
        return { ok: false, error: "pf2e.cg_unknown_class", sheet: result[:sheet] }
      end

      sheet = result[:sheet]
      options = Array((entry["key_ability"] || {})["options"]).map { |a| ability_key(a) || a.to_s }

      chosen = key_ability ? ability_key(key_ability) : nil
      if options.size == 1
        chosen ||= options.first
      end

      if options.any?
        if chosen.nil?
          return { ok: false, error: "pf2e.cg_need_key_ability", sheet: sheet }
        end
        unless options.include?(chosen)
          return { ok: false, error: "pf2e.cg_invalid_key_ability", sheet: sheet }
        end
      end

      charclass = {
        "slug" => key,
        "name" => entry["name"] || key,
        "key_ability" => chosen
      }
      sheet.update(charclass: charclass)

      if entry["perception"]
        set_save_rank(sheet, "perception", entry["perception"])
      end
      saves = entry["saves"] || {}
      saves.each do |save_name, rank|
        set_save_rank(sheet, save_name, rank)
      end

      additional = ((entry["skills"] || {})["additional"]) || []
      Array(additional).each do |sk|
        sk_key = sk.to_s.strip.downcase
        next if sk_key.empty?
        current = skill_rank(sheet, sk_key)
        set_skill_rank(sheet, sk_key, "T") if current == "U"
      end

      cg_recalc_abilities(sheet)
      cg_recalc_hp(sheet)

      { ok: true, error: nil, sheet: sheet, entry: entry }
    end

    def self.cg_recalc_hp(sheet)
      return unless sheet

      level = [sheet.level.to_i, 1].max
      anc = cg_ancestry_entry(sheet.ancestry)
      anc_hp = anc.is_a?(Hash) ? anc["hp"].to_i : 0

      cc = sheet.charclass || {}
      class_entry = cg_class_entry(cc["slug"] || cc[:slug])
      class_hp = class_entry.is_a?(Hash) ? class_entry["hp"].to_i : 0

      con_mod = ability_mod(sheet, "con")
      max = anc_hp + (class_hp + con_mod) * level
      max = [max, 1].max

      hp = (sheet.hp || {}).dup
      hp["max"] = max
      if hp["current"].to_i <= 0
        hp["current"] = max
      elsif hp["current"].to_i > max
        hp["current"] = max
      end
      hp["temp"] = hp["temp"].to_i
      sheet.update(hp: hp)
      max
    end

  end
end

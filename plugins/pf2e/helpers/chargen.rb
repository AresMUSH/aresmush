module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Chargen helpers
    # Pure logic for sheet setup. Commands and (later) web
    # both call these; they return a result hash:
    #   { ok: true/false, error: "locale key or message", sheet: Pf2eSheet }
    # -------------------------------------------------

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

    # Set ancestry slug. Clears heritage if it is no longer valid.
    # Applies ancestry speed. HP is recalculated when class is known.
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

      # Drop heritage if it does not belong to the new ancestry
      allowed = Array(entry["heritages"]).map { |h| h.to_s }
      if sheet.heritage && !allowed.include?(sheet.heritage.to_s)
        updates[:heritage] = nil
      end

      if entry["speed"]
        updates[:speed] = entry["speed"].to_i
      end

      sheet.update(updates)
      cg_recalc_hp(sheet)

      { ok: true, error: nil, sheet: sheet, entry: entry }
    end

    # Set heritage; must match current ancestry's list.
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

      # Optional parent check on the heritage record itself
      parent = entry["ancestry"].to_s
      if !parent.empty? && parent != sheet.ancestry.to_s
        return { ok: false, error: "pf2e.cg_heritage_not_for_ancestry", sheet: sheet }
      end

      sheet.update(heritage: key)
      { ok: true, error: nil, sheet: sheet, entry: entry }
    end

    # Set background slug. Trains listed skills (if still U) and adds feat slug.
    # Free ability boosts are not auto-applied (separate step / web UI).
    def self.cg_set_background(char, slug)
      result = cg_ensure_sheet(char)
      return result unless result[:ok]

      key = slug.to_s.strip.downcase
      entry = cg_background_entry(key)
      unless entry.is_a?(Hash)
        return { ok: false, error: "pf2e.cg_unknown_background", sheet: result[:sheet] }
      end

      sheet = result[:sheet]
      sheet.update(background: key)

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

      { ok: true, error: nil, sheet: sheet, entry: entry }
    end

    # Set class. key_ability must be one of the class options when provided.
    # Applies starting Perception/save ranks and class-granted skill training.
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

      # Starting perception / saves from class data
      if entry["perception"]
        set_save_rank(sheet, "perception", entry["perception"])
      end
      saves = entry["saves"] || {}
      saves.each do |save_name, rank|
        set_save_rank(sheet, save_name, rank)
      end

      # Class-granted skills
      additional = ((entry["skills"] || {})["additional"]) || []
      Array(additional).each do |sk|
        sk_key = sk.to_s.strip.downcase
        next if sk_key.empty?
        current = skill_rank(sheet, sk_key)
        set_skill_rank(sheet, sk_key, "T") if current == "U"
      end

      cg_recalc_hp(sheet)

      { ok: true, error: nil, sheet: sheet, entry: entry }
    end

    # Ancestry HP + class HP/level + CON mod per level (level 1 for now).
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
      # Only fill current if it was zero / unset so we do not clobber damage mid-play
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

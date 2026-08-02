module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Language helpers
    # -------------------------------------------------

    def self.language_entry(slug)
      return nil if slug.nil? || slug.to_s.strip.empty?
      read_data("languages", slug.to_s.strip.downcase)
    end

    def self.cg_known_languages(sheet)
      Array(sheet.languages).map { |s| s.to_s.strip.downcase }.reject(&:empty?).uniq
    end

    def self.cg_add_language(sheet, slug)
      key = slug.to_s.strip.downcase
      return false if key.empty?
      return false unless language_entry(key)

      known = cg_known_languages(sheet)
      return true if known.include?(key)

      known << key
      sheet.update(languages: known)
      true
    end

    # Languages every PC receives (society: true in catalog).
    def self.cg_society_languages
      data = read_data("languages") || {}
      data.select { |_k, v| v.is_a?(Hash) && v["society"] }.keys.map(&:to_s)
    end

    # Fixed grants from ancestry + class (not free picks).
    def self.cg_granted_languages(sheet)
      granted = []

      # Universal baseline
      granted << "tradetongue"

      anc = cg_ancestry_entry(sheet.ancestry)
      if anc.is_a?(Hash)
        Array((anc["languages"] || {})["starting"]).each { |s| granted << s.to_s.strip.downcase }
      end

      cc = sheet.charclass || {}
      class_entry = cg_class_entry(cc["slug"] || cc[:slug])
      if class_entry.is_a?(Hash)
        Array((class_entry["languages"] || {})["starting"]).each { |s| granted << s.to_s.strip.downcase }
      end

      granted.concat(cg_society_languages)
      granted.reject(&:empty?).uniq
    end

    # How many free language picks the character still owes (Int-based + class additional).
    def self.cg_language_picks_total(sheet)
      total = 0
      anc = cg_ancestry_entry(sheet.ancestry)
      if anc.is_a?(Hash) && (anc["languages"] || {})["additional_per_int"]
        total += [ability_mod(sheet, "int"), 0].max
      end

      cc = sheet.charclass || {}
      class_entry = cg_class_entry(cc["slug"] || cc[:slug])
      if class_entry.is_a?(Hash)
        total += ((class_entry["languages"] || {})["additional"] || 0).to_i
      end

      total
    end

    def self.cg_language_picks_used(sheet)
      granted = cg_granted_languages(sheet)
      known = cg_known_languages(sheet)
      (known - granted).size
    end

    def self.cg_language_picks_remaining(sheet)
      [cg_language_picks_total(sheet) - cg_language_picks_used(sheet), 0].max
    end

    # Eligible free-pick languages: not restricted, not already known.
    # Default: common rarity only (includes regional commons).
    def self.cg_language_pick_options(sheet)
      known = cg_known_languages(sheet)
      data = read_data("languages") || {}

      # Ancestry may narrow options
      anc = cg_ancestry_entry(sheet.ancestry)
      option_filter = nil
      if anc.is_a?(Hash)
        raw = (anc["languages"] || {})["additional_options"]
        option_filter = Array(raw).map { |s| s.to_s.strip.downcase } if raw
      end

      data.keys.sort.map do |slug|
        entry = data[slug]
        next nil unless entry.is_a?(Hash)
        next nil if entry["restricted"]
        next nil if known.include?(slug.to_s)
        next nil if option_filter && !option_filter.include?(slug.to_s)
        # Free picks: common only unless you later expand policy
        next nil unless entry["rarity"].to_s == "common"

        {
          slug: slug.to_s,
          name: entry["name"] || slug.to_s,
          note: [
            entry["regional"] ? "regional" : nil,
            entry["spoken"] == false ? "not spoken" : nil,
            entry["written"] == false ? "not written" : nil,
            entry["signed"] ? "signed" : nil
          ].compact.join(", ")
        }
      end.compact
    end

    def self.cg_language_status(char)
      result = cg_ensure_sheet(char)
      return result unless result[:ok]
      sheet = result[:sheet]
      locked = cg_require_identity_locked(sheet)
      return locked if locked

      {
        ok: true,
        error: nil,
        sheet: sheet,
        known: cg_known_languages(sheet),
        granted: cg_granted_languages(sheet),
        total: cg_language_picks_total(sheet),
        used: cg_language_picks_used(sheet),
        remaining: cg_language_picks_remaining(sheet),
        options: cg_language_pick_options(sheet)
      }
    end

    def self.cg_pick_language(char, slug)
      result = cg_ensure_sheet(char)
      return result unless result[:ok]
      sheet = result[:sheet]
      locked = cg_require_identity_locked(sheet)
      return locked if locked

      key = slug.to_s.strip.downcase
      entry = language_entry(key)
      return { ok: false, error: "pf2e.cg_unknown_language", sheet: sheet } unless entry

      if entry["restricted"]
        return { ok: false, error: "pf2e.cg_language_restricted", sheet: sheet }
      end

      if cg_known_languages(sheet).include?(key)
        return { ok: false, error: "pf2e.cg_language_known", sheet: sheet }
      end

      if cg_language_picks_remaining(sheet) <= 0
        return { ok: false, error: "pf2e.cg_language_no_picks", sheet: sheet }
      end

      allowed = cg_language_pick_options(sheet).map { |r| r[:slug] }
      unless allowed.include?(key)
        return { ok: false, error: "pf2e.cg_language_not_allowed", sheet: sheet }
      end

      cg_add_language(sheet, key)
      {
        ok: true,
        error: nil,
        sheet: sheet,
        language: key,
        remaining: cg_language_picks_remaining(sheet)
      }
    end

    # Seed granted languages (ancestry + class + society + tradetongue).
    # Called from cg_commit_identity.
    def self.cg_apply_granted_languages(sheet)
      cg_granted_languages(sheet).each { |slug| cg_add_language(sheet, slug) }
      cg_known_languages(sheet)
    end

  end
end

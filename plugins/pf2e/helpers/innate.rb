module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Innate spells (Player Core)
    #
    # Stored under sheet.magic["innate"]:
    #   casting: innate
    #   progression: none
    #   attribute: cha          # default key ability
    #   spells: [
    #     {
    #       slug: detect_magic
    #       tradition: arcane
    #       rank: 0             # base rank as granted (not auto-heightened except cantrips)
    #       frequency: at_will | per_day
    #       per_day: 1          # when frequency is per_day
    #       used: 0
    #       attribute: cha      # optional per-spell override
    #       grant: optional audit string (feat/ancestry slug)
    #     }
    #   ]
    #
    # Rules mirrored:
    #   - No spell slots; uses refresh on daily prep
    #   - Trained in innate spell attack/DC; Expert at level 12+
    #   - If class spellcasting proficiency is higher, use that
    #   - Default attribute Charisma unless specified
    # -------------------------------------------------

    INNATE_SOURCE = "innate".freeze unless const_defined?(:INNATE_SOURCE)

    def self.innate_source(char_or_sheet)
      entry = magic_source(char_or_sheet, INNATE_SOURCE)
      return entry if entry.is_a?(Hash)
      nil
    end

    def self.ensure_innate_source(sheet)
      existing = innate_source(sheet)
      return existing if existing

      attrs = {
        "casting" => "innate",
        "progression" => "none",
        "attribute" => "cha",
        "tradition" => nil,
        "proficiency" => "T",
        "spells" => [],
        "slots" => {},
        "cantrips" => [],
        "spellbook" => [],
        "repertoire" => {},
        "prepared" => {},
        "focus_spells" => []
      }
      set_magic_source(sheet, INNATE_SOURCE, attrs)
      innate_source(sheet)
    end

    # Baseline innate proficiency: Trained; Expert at 12+.
    # Raise to class spellcasting proficiency when higher.
    def self.innate_proficiency(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      return "T" unless sheet

      baseline = sheet.level.to_i >= 12 ? "E" : "T"
      best = baseline

      magic_hash(sheet).each do |src, entry|
        next unless entry.is_a?(Hash)
        next if src.to_s == INNATE_SOURCE
        casting = entry["casting"].to_s.downcase
        next if casting == "innate" || casting.empty?
        # Only sources with real spellcasting progression/slots or explicit proficiency
        rank = entry["proficiency"].to_s.upcase
        next if rank.empty?
        best = rank if teml_rank_value(rank) > teml_rank_value(best)
      end

      best
    end

    def self.innate_attribute(char_or_sheet, spell_hash = nil)
      if spell_hash.is_a?(Hash)
        override = spell_hash["attribute"] || spell_hash["ability"]
        key = ability_key(override)
        return key if key
      end
      entry = innate_source(char_or_sheet)
      if entry.is_a?(Hash)
        key = ability_key(entry["attribute"] || entry["ability"])
        return key if key
      end
      "cha"
    end

    def self.innate_spell_dc(char_or_sheet, spell_slug = nil, other_bonus: 0)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      spell = spell_slug ? find_innate_spell(sheet, spell_slug) : nil
      ability = innate_attribute(sheet, spell)
      rank = innate_proficiency(sheet)
      dc = spell_dc(sheet, ability: ability, rank: rank, other_bonus: other_bonus)
      {
        ok: true,
        source: INNATE_SOURCE,
        value: dc,
        ability: ability,
        rank: rank,
        kind: :spell_dc,
        spell: spell ? spell["slug"] : nil
      }
    end

    def self.innate_spell_attack_mod(char_or_sheet, spell_slug = nil, other_bonus: 0)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      spell = spell_slug ? find_innate_spell(sheet, spell_slug) : nil
      ability = innate_attribute(sheet, spell)
      rank = innate_proficiency(sheet)
      mod = spell_attack_mod(sheet, ability: ability, rank: rank, other_bonus: other_bonus)
      {
        ok: true,
        source: INNATE_SOURCE,
        value: mod,
        ability: ability,
        rank: rank,
        kind: :spell_attack,
        spell: spell ? spell["slug"] : nil
      }
    end

    def self.find_innate_spell(char_or_sheet, slug)
      entry = innate_source(char_or_sheet)
      return nil unless entry
      key = slug.to_s.strip.downcase
      Array(entry["spells"]).find { |s| s.is_a?(Hash) && s["slug"].to_s.downcase == key }
    end

    def self.list_innate_spells(char_or_sheet)
      entry = innate_source(char_or_sheet)
      return [] unless entry
      Array(entry["spells"]).select { |s| s.is_a?(Hash) }
    end

    # Grant or update an innate spell. Idempotent on slug.
    def self.innate_grant(char_or_sheet, slug:, tradition: nil, rank: nil, frequency: nil, per_day: 1, attribute: nil, grant: nil)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      key = slug.to_s.strip.downcase
      return { ok: false, error: "pf2e.magic_unknown_spell", spells: [key] } if key.empty?

      catalog = spell_entry(key)
      # Allow grants even if catalog not filled yet, but prefer catalog rank.
      base_rank = rank.nil? ? (catalog.is_a?(Hash) ? catalog["rank"].to_i : 0) : rank.to_i
      trad = tradition || (catalog.is_a?(Hash) ? Array(catalog["traditions"]).first : nil)

      freq = frequency.to_s.strip.downcase
      if freq.empty?
        freq = (base_rank == 0) ? "at_will" : "per_day"
      end
      freq = "at_will" if freq == "atwill" || freq == "will"

      ensure_innate_source(sheet)
      entry = innate_source(sheet).dup
      spells = Array(entry["spells"]).map { |s| s.is_a?(Hash) ? s.dup : s }

      existing = spells.find { |s| s.is_a?(Hash) && s["slug"].to_s.downcase == key }
      if existing
        existing["tradition"] = trad.to_s.downcase if trad
        existing["rank"] = base_rank
        existing["frequency"] = freq
        existing["per_day"] = per_day.to_i if freq == "per_day"
        existing["attribute"] = ability_key(attribute) if attribute
        existing["grant"] = grant.to_s if grant
      else
        row = {
          "slug" => key,
          "tradition" => trad.to_s.downcase,
          "rank" => base_rank,
          "frequency" => freq,
          "per_day" => (freq == "per_day" ? per_day.to_i : 0),
          "used" => 0
        }
        row["attribute"] = ability_key(attribute) if attribute
        row["grant"] = grant.to_s if grant
        spells << row
      end

      entry["spells"] = spells
      set_magic_source(sheet, INNATE_SOURCE, entry)
      { ok: true, source: INNATE_SOURCE, spell: key, frequency: freq }
    end

    def self.innate_remove(char_or_sheet, slug)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet
      entry = innate_source(sheet)
      return { ok: false, error: "pf2e.innate_not_found", spell: slug } unless entry

      key = slug.to_s.strip.downcase
      spells = Array(entry["spells"]).reject { |s| s.is_a?(Hash) && s["slug"].to_s.downcase == key }
      if spells.size == Array(entry["spells"]).size
        return { ok: false, error: "pf2e.innate_not_found", spell: key }
      end

      e = entry.dup
      e["spells"] = spells
      set_magic_source(sheet, INNATE_SOURCE, e)
      { ok: true, spell: key }
    end

    # Spend one daily use (at-will always succeeds without changing used).
    def self.innate_cast(char_or_sheet, slug)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      key = slug.to_s.strip.downcase
      entry = innate_source(sheet)
      return { ok: false, error: "pf2e.innate_not_found", spell: key } unless entry

      spells = Array(entry["spells"]).map { |s| s.is_a?(Hash) ? s.dup : s }
      spell = spells.find { |s| s.is_a?(Hash) && s["slug"].to_s.downcase == key }
      return { ok: false, error: "pf2e.innate_not_found", spell: key } unless spell

      freq = spell["frequency"].to_s.downcase
      if freq == "at_will" || freq == "atwill"
        dc_info = innate_spell_dc(sheet, key)
        atk_info = innate_spell_attack_mod(sheet, key)
        return {
          ok: true,
          spell: key,
          frequency: "at_will",
          used: 0,
          max: 0,
          dc: dc_info[:value],
          attack: atk_info[:value],
          rank: spell["rank"].to_i,
          tradition: spell["tradition"]
        }
      end

      max = [spell["per_day"].to_i, 1].max
      used = spell["used"].to_i
      if used >= max
        return { ok: false, error: "pf2e.innate_exhausted", spell: key, used: used, max: max }
      end

      spell["used"] = used + 1
      e = entry.dup
      e["spells"] = spells
      set_magic_source(sheet, INNATE_SOURCE, e)

      dc_info = innate_spell_dc(sheet, key)
      atk_info = innate_spell_attack_mod(sheet, key)
      {
        ok: true,
        spell: key,
        frequency: "per_day",
        used: spell["used"],
        max: max,
        dc: dc_info[:value],
        attack: atk_info[:value],
        rank: spell["rank"].to_i,
        tradition: spell["tradition"]
      }
    end

    def self.innate_daily_reset!(sheet)
      entry = innate_source(sheet)
      return unless entry

      spells = Array(entry["spells"]).map do |s|
        next s unless s.is_a?(Hash)
        row = s.dup
        row["used"] = 0
        row
      end
      e = entry.dup
      e["spells"] = spells
      # Keep displayed proficiency in sync
      e["proficiency"] = innate_proficiency(sheet)
      set_magic_source(sheet, INNATE_SOURCE, e)
    end

    def self.format_innate_lines(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      return [] unless sheet
      spells = list_innate_spells(sheet)
      return [] if spells.empty?

      rank = innate_proficiency(sheet)
      abil = innate_attribute(sheet)
      dc_info = innate_spell_dc(sheet)
      atk_info = innate_spell_attack_mod(sheet)
      dc = dc_info[:ok] ? dc_info[:value] : "?"
      atk = atk_info[:ok] ? atk_info[:value] : "?"

      lines = []
      lines << "%xhinnate%xn  #{abil.upcase} #{rank}  DC #{dc}  Attack +#{atk}"
      spells.each do |s|
        slug = s["slug"]
        trad = s["tradition"] || "-"
        sr = s["rank"].to_i
        freq = s["frequency"].to_s.downcase
        if freq == "at_will" || freq == "atwill"
          uses = "at-will"
        else
          uses = "#{s['used'].to_i}/#{[s['per_day'].to_i, 1].max}/day"
        end
        grant = s["grant"].to_s.empty? ? "" : "  [#{s['grant']}]"
        lines << "  #{slug}  R#{sr} #{trad}  #{uses}#{grant}"
      end
      lines
    end

  end
end

module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Spellcasting sources (multi-tradition / multiclass)
    #
    # sheet.magic is a hash keyed by source slug:
    #   "wizard", "bard", "druid_dedication", ...
    #
    # Each source:
    #   tradition:   arcane|divine|occult|primal
    #   casting:     prepared|spontaneous|focus
    #   attribute:   int|wis|cha (spell attack / DC key ability)
    #   proficiency: TEML rank for spell attack and spell DC
    #   cantrips:    [slug, ...]   known/available cantrips
    #   spellbook:   [slug, ...]   prepared casters only (library)
    #   repertoire:  { "1" => [slug], "2" => [...] }  spontaneous known
    #   prepared:    { "cantrip" => [slug], "1" => [slug] }  today's list
    #   slots:       { "1" => { "max" => 2, "used" => 0 }, ... }
    #   focus_spells:[slug, ...]   focus tradition spells on this source
    #
    # Focus *points* are character-level: sheet.focus_points
    # (single shared pool in PF2e).
    # -------------------------------------------------

    def self.magic_hash(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      return {} unless sheet
      h = sheet.magic
      h.is_a?(Hash) ? h : {}
    end

    def self.magic_sources(char_or_sheet)
      magic_hash(char_or_sheet).keys.map(&:to_s).sort
    end

    def self.magic_source(char_or_sheet, source)
      key = normalize_magic_source(source)
      return nil if key.nil?
      entry = magic_hash(char_or_sheet)[key]
      entry.is_a?(Hash) ? entry : nil
    end

    def self.normalize_magic_source(source)
      return nil if source.nil?
      s = source.to_s.strip.downcase.gsub(/[\s-]+/, "_")
      s.empty? ? nil : s
    end

    # Resolve which source to use for DC / attack.
    # - explicit source wins
    # - if only one source, use it
    # - if multiple and none given → error hash
    def self.resolve_magic_source(char_or_sheet, source = nil)
      sources = magic_sources(char_or_sheet)
      return { ok: false, error: "pf2e.magic_no_sources", sources: [] } if sources.empty?

      if source.nil? || source.to_s.strip.empty?
        if sources.size == 1
          return { ok: true, source: sources.first, entry: magic_source(char_or_sheet, sources.first) }
        end
        return { ok: false, error: "pf2e.magic_source_required", sources: sources }
      end

      key = normalize_magic_source(source)
      entry = magic_source(char_or_sheet, key)
      unless entry
        return { ok: false, error: "pf2e.magic_unknown_source", sources: sources, source: key }
      end
      { ok: true, source: key, entry: entry }
    end

    def self.spell_entry(slug)
      return nil if slug.nil?
      read_data("spells", slug.to_s.strip.downcase)
    end

    # --- Attack / DC from a source ---

    def self.magic_spell_dc(char_or_sheet, source = nil, other_bonus: 0)
      resolved = resolve_magic_source(char_or_sheet, source)
      return resolved unless resolved[:ok]

      entry = resolved[:entry]
      ability = entry["attribute"] || entry["ability"] || "cha"
      rank = (entry["proficiency"] || "T").to_s
      dc = spell_dc(char_or_sheet, ability: ability, rank: rank, other_bonus: other_bonus)
      resolved.merge(value: dc, ability: ability, rank: rank, kind: :spell_dc)
    end

    def self.magic_spell_attack_mod(char_or_sheet, source = nil, other_bonus: 0)
      resolved = resolve_magic_source(char_or_sheet, source)
      return resolved unless resolved[:ok]

      entry = resolved[:entry]
      ability = entry["attribute"] || entry["ability"] || "cha"
      rank = (entry["proficiency"] || "T").to_s
      mod = spell_attack_mod(char_or_sheet, ability: ability, rank: rank, other_bonus: other_bonus)
      resolved.merge(value: mod, ability: ability, rank: rank, kind: :spell_attack)
    end

    # Convenience integers for roll keywords (nil on ambiguity/error)
    def self.spell_dc_for(char_or_sheet, source = nil)
      r = magic_spell_dc(char_or_sheet, source)
      r[:ok] ? r[:value] : nil
    end

    def self.spell_attack_for(char_or_sheet, source = nil)
      r = magic_spell_attack_mod(char_or_sheet, source)
      r[:ok] ? r[:value] : nil
    end

    # --- Mutators ---

    def self.set_magic_source(char_or_sheet, source, attrs)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet
      key = normalize_magic_source(source)
      return { ok: false, error: "pf2e.magic_unknown_source" } if key.nil?

      magic = magic_hash(sheet).dup
      current = magic[key].is_a?(Hash) ? magic[key].dup : default_magic_source
      attrs.each { |k, v| current[k.to_s] = v }
      magic[key] = current
      sheet.update(magic: magic)
      { ok: true, source: key, entry: current }
    end

    def self.default_magic_source
      {
        "tradition" => nil,
        "casting" => "prepared",
        "attribute" => "cha",
        "proficiency" => "T",
        "cantrips" => [],
        "spellbook" => [],
        "repertoire" => {},
        "prepared" => {},
        "slots" => {},
        "focus_spells" => []
      }
    end

    # Daily / rest: clear slot usage; do NOT clear prepared list.
    # Focus points restored to max if focus_max provided or inferred.
    def self.magic_daily_reset(char_or_sheet, restore_focus: true)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      magic = magic_hash(sheet).dup
      magic.each do |src, entry|
        next unless entry.is_a?(Hash)
        e = entry.dup
        slots = (e["slots"] || {}).dup
        slots.each do |rank, slot|
          next unless slot.is_a?(Hash)
          s = slot.dup
          s["used"] = 0
          slots[rank] = s
        end
        e["slots"] = slots
        magic[src] = e
      end
      sheet.update(magic: magic)

      if restore_focus
        max_fp = magic_focus_max(sheet)
        sheet.update(focus_points: max_fp) if max_fp > 0
      end

      { ok: true, sources: magic.keys.map(&:to_s), focus_points: sheet.focus_points.to_i }
    end

    def self.magic_focus_max(char_or_sheet)
      # Character-level pool. Prefer explicit sheet value if higher;
      # otherwise at least 1 if any focus spells exist, else 0.
      sheet = sheet_for(char_or_sheet)
      return 0 unless sheet
      has_focus = magic_hash(sheet).any? do |_, e|
        e.is_a?(Hash) && Array(e["focus_spells"]).any?
      end
      return 0 unless has_focus
      # PF2e default: start with 1; features may raise. Staff/class code sets
      # focus_points max via features later. Use current max of (1, current).
      [sheet.focus_points.to_i, 1].max
    end

    # Prepare spells for a prepared source (replaces that rank's prepared list).
    # ranks_hash: { "cantrip" => ["shield", "light"], "1" => ["magic_missile"] }
    def self.magic_prepare(char_or_sheet, source, ranks_hash)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      resolved = resolve_magic_source(sheet, source)
      return resolved unless resolved[:ok]

      entry = resolved[:entry].dup
      casting = entry["casting"].to_s.downcase
      unless casting == "prepared" || casting.empty?
        return { ok: false, error: "pf2e.magic_not_prepared", source: resolved[:source] }
      end

      prepared = (entry["prepared"] || {}).dup
      library = (
        Array(entry["cantrips"]) + Array(entry["spellbook"])
      ).map { |s| s.to_s.strip.downcase }.uniq

      Array(ranks_hash).each do |rank, slugs|
        rank_key = rank.to_s.strip.downcase
        list = Array(slugs).map { |s| s.to_s.strip.downcase }.reject(&:empty?)
        unknown = list.reject { |s| library.include?(s) || spell_entry(s) }
        # Allow catalog spells even if not yet in spellbook during early data fill;
        # still warn by requiring spell_entry existence.
        missing_catalog = list.reject { |s| spell_entry(s) }
        if missing_catalog.any?
          return {
            ok: false,
            error: "pf2e.magic_unknown_spell",
            spells: missing_catalog
          }
        end
        prepared[rank_key] = list
      end

      entry["prepared"] = prepared
      magic = magic_hash(sheet).dup
      magic[resolved[:source]] = entry
      sheet.update(magic: magic)
      { ok: true, source: resolved[:source], prepared: prepared }
    end

    # Add spell to spellbook (prepared) or repertoire (spontaneous).
    def self.magic_learn(char_or_sheet, source, spell_slug, rank: nil)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      resolved = resolve_magic_source(sheet, source)
      return resolved unless resolved[:ok]

      slug = spell_slug.to_s.strip.downcase
      sp = spell_entry(slug)
      return { ok: false, error: "pf2e.magic_unknown_spell", spells: [slug] } unless sp

      entry = resolved[:entry].dup
      casting = entry["casting"].to_s.downcase
      spell_rank = (rank || sp["rank"]).to_i

      if spell_rank == 0
        cantrips = Array(entry["cantrips"]).map { |s| s.to_s.downcase }
        cantrips << slug unless cantrips.include?(slug)
        entry["cantrips"] = cantrips
      elsif casting == "spontaneous"
        rep = (entry["repertoire"] || {}).dup
        key = spell_rank.to_s
        list = Array(rep[key]).map { |s| s.to_s.downcase }
        list << slug unless list.include?(slug)
        rep[key] = list
        entry["repertoire"] = rep
      else
        book = Array(entry["spellbook"]).map { |s| s.to_s.downcase }
        book << slug unless book.include?(slug)
        entry["spellbook"] = book
      end

      magic = magic_hash(sheet).dup
      magic[resolved[:source]] = entry
      sheet.update(magic: magic)
      { ok: true, source: resolved[:source], spell: slug, rank: spell_rank, casting: casting }
    end

    def self.magic_spend_slot(char_or_sheet, source, rank)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet
      resolved = resolve_magic_source(sheet, source)
      return resolved unless resolved[:ok]

      entry = resolved[:entry].dup
      slots = (entry["slots"] || {}).dup
      key = rank.to_s
      slot = slots[key]
      return { ok: false, error: "pf2e.magic_no_slot_rank", rank: key } unless slot.is_a?(Hash)

      used = slot["used"].to_i
      max = slot["max"].to_i
      return { ok: false, error: "pf2e.magic_slots_exhausted", rank: key } if used >= max

      slot = slot.dup
      slot["used"] = used + 1
      slots[key] = slot
      entry["slots"] = slots
      magic = magic_hash(sheet).dup
      magic[resolved[:source]] = entry
      sheet.update(magic: magic)
      { ok: true, source: resolved[:source], rank: key, used: slot["used"], max: max }
    end

    def self.format_magic_status(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      return t('pf2e.no_sheet') unless sheet

      sources = magic_sources(sheet)
      lines = []
      lines << "%xhSpellcasting%xn  Focus points: #{sheet.focus_points.to_i}"
      if sources.empty?
        lines << "  (no spellcasting sources)"
        return lines.join("%r")
      end

      sources.each do |src|
        entry = magic_source(sheet, src)
        next unless entry
        dc_info = magic_spell_dc(sheet, src)
        atk_info = magic_spell_attack_mod(sheet, src)
        dc = dc_info[:ok] ? dc_info[:value] : "?"
        atk = atk_info[:ok] ? atk_info[:value] : "?"
        trad = entry["tradition"] || "-"
        cast = entry["casting"] || "-"
        abil = (entry["attribute"] || entry["ability"] || "?").to_s.upcase
        rank = entry["proficiency"] || "T"

        lines << "%xh#{src}%xn  #{trad}/#{cast}  #{abil} #{rank}  DC #{dc}  Attack +#{atk}"

        slots = entry["slots"] || {}
        if slots.any?
          slot_bits = slots.keys.sort_by(&:to_i).map do |r|
            s = slots[r]
            s.is_a?(Hash) ? "R#{r} #{s['used'].to_i}/#{s['max'].to_i}" : "R#{r}"
          end
          lines << "  Slots: #{slot_bits.join(', ')}"
        end

        cantrips = Array(entry["cantrips"])
        lines << "  Cantrips: #{cantrips.empty? ? '-' : cantrips.join(', ')}"

        prepared = entry["prepared"] || {}
        if prepared.any?
          prepared.keys.sort_by { |k| k.to_s == 'cantrip' ? 0 : k.to_i }.each do |r|
            list = Array(prepared[r])
            next if list.empty?
            label = r.to_s == 'cantrip' ? 'Cantrip prep' : "Rank #{r} prep"
            lines << "  #{label}: #{list.join(', ')}"
          end
        end

        rep = entry["repertoire"] || {}
        if rep.any?
          rep.keys.sort_by(&:to_i).each do |r|
            list = Array(rep[r])
            next if list.empty?
            lines << "  Repertoire R#{r}: #{list.join(', ')}"
          end
        end

        book = Array(entry["spellbook"])
        lines << "  Spellbook: #{book.join(', ')}" if book.any?

        focus = Array(entry["focus_spells"])
        lines << "  Focus spells: #{focus.join(', ')}" if focus.any?
      end

      if sources.size > 1
        lines << "%xhNote:%xn Multiple sources — use spell_dc:<source> / spell_attack:<source> when rolling."
      end

      lines.join("%r")
    end

  end
end

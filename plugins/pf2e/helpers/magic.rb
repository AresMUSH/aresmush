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
    #   cantrips_max: Integer
    #   spellbook:   [slug, ...]   prepared casters only (library)
    #   repertoire:  { "1" => [slug], "2" => [...] }  spontaneous known
    #   prepared:    { "cantrip" => [slug], "1" => [slug] }  today's list
    #   slots:       { "1" => { "max" => 2, "used" => 0 }, ... }
    #   focus_spells:[slug, ...]   focus tradition spells on this source
    #   progression: full | bounded | none
    #
    # Focus *points* are character-level: sheet.focus_points
    # (single shared pool in PF2e).
    # -------------------------------------------------

    # Full spellcaster slot table (Player Core: wizard, cleric, druid, witch,
    # sorcerer, oracle, bard, psychic, etc.). Values are [cantrips_max, slots_hash].
    FULL_CASTER_SLOTS = {
      1  => [5, { 1 => 2 }],
      2  => [5, { 1 => 3 }],
      3  => [5, { 1 => 3, 2 => 2 }],
      4  => [5, { 1 => 3, 2 => 3 }],
      5  => [5, { 1 => 3, 2 => 3, 3 => 2 }],
      6  => [5, { 1 => 3, 2 => 3, 3 => 3 }],
      7  => [5, { 1 => 3, 2 => 3, 3 => 3, 4 => 2 }],
      8  => [5, { 1 => 3, 2 => 3, 3 => 3, 4 => 3 }],
      9  => [5, { 1 => 3, 2 => 3, 3 => 3, 4 => 3, 5 => 2 }],
      10 => [5, { 1 => 3, 2 => 3, 3 => 3, 4 => 3, 5 => 3 }],
      11 => [5, { 1 => 3, 2 => 3, 3 => 3, 4 => 3, 5 => 3, 6 => 2 }],
      12 => [5, { 1 => 3, 2 => 3, 3 => 3, 4 => 3, 5 => 3, 6 => 3 }],
      13 => [5, { 1 => 3, 2 => 3, 3 => 3, 4 => 3, 5 => 3, 6 => 3, 7 => 2 }],
      14 => [5, { 1 => 3, 2 => 3, 3 => 3, 4 => 3, 5 => 3, 6 => 3, 7 => 3 }],
      15 => [5, { 1 => 3, 2 => 3, 3 => 3, 4 => 3, 5 => 3, 6 => 3, 7 => 3, 8 => 2 }],
      16 => [5, { 1 => 3, 2 => 3, 3 => 3, 4 => 3, 5 => 3, 6 => 3, 7 => 3, 8 => 3 }],
      17 => [5, { 1 => 3, 2 => 3, 3 => 3, 4 => 3, 5 => 3, 6 => 3, 7 => 3, 8 => 3, 9 => 2 }],
      18 => [5, { 1 => 3, 2 => 3, 3 => 3, 4 => 3, 5 => 3, 6 => 3, 7 => 3, 8 => 3, 9 => 3 }],
      19 => [5, { 1 => 3, 2 => 3, 3 => 3, 4 => 3, 5 => 3, 6 => 3, 7 => 3, 8 => 3, 9 => 3, 10 => 1 }],
      20 => [5, { 1 => 3, 2 => 3, 3 => 3, 4 => 3, 5 => 3, 6 => 3, 7 => 3, 8 => 3, 9 => 3, 10 => 1 }]
    }.freeze unless const_defined?(:FULL_CASTER_SLOTS)

    # Bounded casters (magus, summoner, some dedications) — simplified sample.
    # Override via class spellcasting.slots_by_level in data if needed.
    BOUNDED_CASTER_SLOTS = {
      1  => [2, { 1 => 1 }],
      2  => [3, { 1 => 2 }],
      3  => [3, { 1 => 2 }],
      4  => [3, { 1 => 2, 2 => 1 }],
      5  => [3, { 1 => 2, 2 => 1 }],
      6  => [3, { 1 => 2, 2 => 2 }],
      7  => [3, { 1 => 2, 2 => 2, 3 => 1 }],
      8  => [3, { 1 => 2, 2 => 2, 3 => 1 }],
      9  => [3, { 1 => 2, 2 => 2, 3 => 2 }],
      10 => [3, { 1 => 2, 2 => 2, 3 => 2, 4 => 1 }],
      11 => [4, { 1 => 2, 2 => 2, 3 => 2, 4 => 1 }],
      12 => [4, { 1 => 2, 2 => 2, 3 => 2, 4 => 2 }],
      13 => [4, { 1 => 2, 2 => 2, 3 => 2, 4 => 2, 5 => 1 }],
      14 => [4, { 1 => 2, 2 => 2, 3 => 2, 4 => 2, 5 => 1 }],
      15 => [4, { 1 => 2, 2 => 2, 3 => 2, 4 => 2, 5 => 2 }],
      16 => [4, { 1 => 2, 2 => 2, 3 => 2, 4 => 2, 5 => 2, 6 => 1 }],
      17 => [4, { 1 => 2, 2 => 2, 3 => 2, 4 => 2, 5 => 2, 6 => 1 }],
      18 => [4, { 1 => 2, 2 => 2, 3 => 2, 4 => 2, 5 => 2, 6 => 2 }],
      19 => [4, { 1 => 2, 2 => 2, 3 => 2, 4 => 2, 5 => 2, 6 => 2, 7 => 1 }],
      20 => [4, { 1 => 2, 2 => 2, 3 => 2, 4 => 2, 5 => 2, 6 => 2, 7 => 1 }]
    }.freeze unless const_defined?(:BOUNDED_CASTER_SLOTS)

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

    def self.spell_dc_for(char_or_sheet, source = nil)
      r = magic_spell_dc(char_or_sheet, source)
      r[:ok] ? r[:value] : nil
    end

    def self.spell_attack_for(char_or_sheet, source = nil)
      r = magic_spell_attack_mod(char_or_sheet, source)
      r[:ok] ? r[:value] : nil
    end

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
        "progression" => "full",
        "cantrips" => [],
        "cantrips_max" => 0,
        "spellbook" => [],
        "repertoire" => {},
        "prepared" => {},
        "slots" => {},
        "focus_spells" => []
      }
    end

    # -------------------------------------------------
    # Class / level-driven source + slots
    # -------------------------------------------------

    def self.slot_table_for(progression)
      case progression.to_s.strip.downcase
      when "bounded" then BOUNDED_CASTER_SLOTS
      when "none", "focus" then {}
      else FULL_CASTER_SLOTS
      end
    end

    # Returns { cantrips_max:, slots: { "1" => max, ... } }
    def self.slots_for_level(level, progression: "full", override_table: nil)
      lvl = [[level.to_i, 1].max, 20].min
      if override_table.is_a?(Hash)
        row = override_table[lvl] || override_table[lvl.to_s]
        if row.is_a?(Hash)
          cantrips = row["cantrips"].to_i
          slots = {}
          (row["slots"] || {}).each { |r, n| slots[r.to_s] = n.to_i }
          return { cantrips_max: cantrips, slots: slots }
        end
      end

      table = slot_table_for(progression)
      row = table[lvl]
      return { cantrips_max: 0, slots: {} } unless row

      cantrips, slots_h = row
      slots = {}
      slots_h.each { |r, n| slots[r.to_s] = n.to_i }
      { cantrips_max: cantrips.to_i, slots: slots }
    end

    # Build / refresh the primary class magic source from charclass.yml.
    # Preserves cantrips, spellbook, repertoire, prepared, focus_spells, used counts
    # when the source already exists.
    def self.sync_class_magic_source(sheet)
      return nil unless sheet
      cc = sheet.charclass || {}
      class_slug = (cc["slug"] || cc[:slug]).to_s.strip.downcase
      return nil if class_slug.empty?

      class_entry = class_entry_for_sheet(sheet) || cg_class_entry(class_slug)
      return nil unless class_entry.is_a?(Hash)

      sc = class_entry["spellcasting"]
      return nil if sc.nil? || sc == false || sc == "null"
      return nil unless sc.is_a?(Hash)

      source_key = normalize_magic_source(sc["source"] || class_slug)
      casting = (sc["type"] || sc["casting"] || "prepared").to_s.downcase
      progression = (sc["progression"] || (casting == "focus" ? "none" : "full")).to_s.downcase
      tradition = sc["tradition"].to_s.downcase
      proficiency = (sc["rank"] || sc["proficiency"] || "T").to_s.upcase

      attribute = sc["attribute"] || sc["ability"]
      if attribute.nil? || attribute.to_s.empty?
        attribute = cc["key_ability"] || cc[:key_ability]
      end
      if attribute.nil? || attribute.to_s.empty?
        opts = ((class_entry["key_ability"] || {})["options"] || [])
        attribute = opts.first
      end
      attribute = ability_key(attribute) || "cha"

      level = [sheet.level.to_i, 1].max
      table_override = sc["slots_by_level"]
      prog = slots_for_level(level, progression: progression, override_table: table_override)

      existing = magic_source(sheet, source_key) || {}
      slots = {}
      prog[:slots].each do |rank, max|
        prev_used = 0
        if existing["slots"].is_a?(Hash) && existing["slots"][rank].is_a?(Hash)
          prev_used = existing["slots"][rank]["used"].to_i
        end
        slots[rank] = { "max" => max, "used" => [prev_used, max].min }
      end

      attrs = {
        "tradition" => tradition.empty? ? nil : tradition,
        "casting" => casting,
        "attribute" => attribute,
        "proficiency" => proficiency,
        "progression" => progression,
        "cantrips_max" => prog[:cantrips_max],
        "slots" => slots,
        "cantrips" => Array(existing["cantrips"]),
        "spellbook" => Array(existing["spellbook"]),
        "repertoire" => existing["repertoire"].is_a?(Hash) ? existing["repertoire"] : {},
        "prepared" => existing["prepared"].is_a?(Hash) ? existing["prepared"] : {},
        "focus_spells" => Array(existing["focus_spells"])
      }

      # Advancement package may raise spell proficiency (expert_spellcaster etc.)
      adv_prof = class_spell_proficiency_at_level(class_entry, level)
      if adv_prof && teml_rank_value(adv_prof) > teml_rank_value(proficiency)
        attrs["proficiency"] = adv_prof.to_s.upcase
      elsif existing["proficiency"]
        # Keep higher of class baseline, existing, or adv
        best = [proficiency, existing["proficiency"].to_s, adv_prof.to_s].max_by { |r| teml_rank_value(r) }
        attrs["proficiency"] = best.upcase if best && !best.empty?
      end

      set_magic_source(sheet, source_key, attrs)
    end

    # Optional: class advancement notes proficiency bumps on spellcasting.
    # Looks for features expert_spellcaster / master_spellcaster / legendary_spellcaster
    # or advancement[N].spellcasting.proficiency.
    def self.class_spell_proficiency_at_level(class_entry, level)
      return nil unless class_entry.is_a?(Hash)
      best = nil
      adv = class_entry["advancement"]
      if adv.is_a?(Hash)
        adv.each do |lvl_key, pkg|
          next if lvl_key.to_i > level.to_i
          next unless pkg.is_a?(Hash)
          sc = pkg["spellcasting"]
          if sc.is_a?(Hash) && sc["proficiency"]
            r = sc["proficiency"].to_s.upcase
            best = r if best.nil? || teml_rank_value(r) > teml_rank_value(best)
          end
          Array(pkg["features"]).each do |f|
            case f.to_s.strip.downcase
            when "expert_spellcaster", "expert_spellcasting"
              best = "E" if best.nil? || teml_rank_value("E") > teml_rank_value(best)
            when "master_spellcaster", "master_spellcasting"
              best = "M" if best.nil? || teml_rank_value("M") > teml_rank_value(best)
            when "legendary_spellcaster", "legendary_spellcasting"
              best = "L" if best.nil? || teml_rank_value("L") > teml_rank_value(best)
            end
          end
        end
      end
      best
    end

    # Sync every existing source that has a progression table (class + future dedications).
    def self.sync_all_magic_slots(sheet)
      return unless sheet
      sync_class_magic_source(sheet)

      magic_hash(sheet).each do |src, entry|
        next unless entry.is_a?(Hash)
        next if src.to_s == ((sheet.charclass || {})["slug"]).to_s
        prog = entry["progression"] || "full"
        next if prog.to_s == "none"
        level = [sheet.level.to_i, 1].max
        info = slots_for_level(level, progression: prog)
        slots = {}
        info[:slots].each do |rank, max|
          prev = 0
          if entry["slots"].is_a?(Hash) && entry["slots"][rank].is_a?(Hash)
            prev = entry["slots"][rank]["used"].to_i
          end
          slots[rank] = { "max" => max, "used" => [prev, max].min }
        end
        set_magic_source(sheet, src, "slots" => slots, "cantrips_max" => info[:cantrips_max])
      end
    end

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
      sheet = sheet_for(char_or_sheet)
      return 0 unless sheet
      has_focus = magic_hash(sheet).any? do |_, e|
        e.is_a?(Hash) && Array(e["focus_spells"]).any?
      end
      return 0 unless has_focus
      [sheet.focus_points.to_i, 1].max
    end

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

      Array(ranks_hash).each do |rank, slugs|
        rank_key = rank.to_s.strip.downcase
        list = Array(slugs).map { |s| s.to_s.strip.downcase }.reject(&:empty?)
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
        cmax = entry["cantrips_max"].to_i

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
        c_label = cmax > 0 ? "#{cantrips.size}/#{cmax}" : cantrips.size.to_s
        lines << "  Cantrips (#{c_label}): #{cantrips.empty? ? '-' : cantrips.join(', ')}"

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
        lines << "%xhNote:%xn Multiple sources - use spell_dc:<source> / spell_attack:<source> when rolling."
      end

      lines.join("%r")
    end

  end
end

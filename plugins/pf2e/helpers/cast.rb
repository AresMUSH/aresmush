module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Unified spell cast (Player Core / Remaster)
    #
    # Handles:
    #   - Innate (delegates to innate_cast)
    #   - Focus spells (spend 1 FP; no slot)
    #   - Cantrips (no slot; must be known on source)
    #   - Prepared (must be prepared at cast rank; spend slot)
    #   - Spontaneous (must be in repertoire at base rank; spend slot at cast rank)
    #
    # Heightening: pass rank higher than the spell's catalog rank; spends that
    # slot rank. Prepared casters must have the slug prepared at that rank.
    # -------------------------------------------------

    def self.magic_cast(char_or_sheet, spell_slug, source: nil, rank: nil)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      slug = spell_slug.to_s.strip.downcase
      return { ok: false, error: "pf2e.magic_cast_usage" } if slug.empty?

      catalog = spell_entry(slug)
      base_rank = catalog.is_a?(Hash) ? catalog["rank"].to_i : nil

      # ----- Explicit innate source, or only match is innate -----
      src_key = normalize_magic_source(source)
      if src_key == INNATE_SOURCE || (src_key.nil? && find_innate_spell(sheet, slug) && !class_known_spell?(sheet, slug))
        return magic_cast_innate(sheet, slug)
      end

      # ----- Focus path: slug on a focus_spells list -----
      focus_hits = focus_spell_entries(sheet).select { |e| e[:slug] == slug }
      if focus_hits.any?
        if src_key
          focus_hits = focus_hits.select { |e| e[:source] == src_key }
          if focus_hits.empty?
            return { ok: false, error: "pf2e.magic_not_known", spell: slug, source: src_key }
          end
        elsif focus_hits.map { |e| e[:source] }.uniq.size > 1 && !class_known_spell?(sheet, slug, exclude_focus: true)
          sources = focus_hits.map { |e| e[:source] }.uniq.sort
          return { ok: false, error: "pf2e.magic_source_required", sources: sources }
        end

        # Prefer focus when the spell is listed as focus (even if also known as a slot spell).
        # Explicit non-focus source with the same slug casts via slots instead.
        unless src_key && !focus_hits.any? { |e| e[:source] == src_key }
          if src_key.nil? || focus_hits.any? { |e| e[:source] == src_key }
            return magic_cast_focus(sheet, slug, source: focus_hits.first[:source], catalog: catalog, base_rank: base_rank)
          end
        end
      end

      # ----- Explicit innate when source was given -----
      if src_key == INNATE_SOURCE
        return magic_cast_innate(sheet, slug)
      end

      # ----- Class / dedication slot casting -----
      resolved = resolve_magic_source(sheet, source)
      return resolved unless resolved[:ok]

      entry = resolved[:entry]
      casting = entry["casting"].to_s.downcase

      if casting == "innate" || resolved[:source] == INNATE_SOURCE
        return magic_cast_innate(sheet, slug)
      end

      # Focus-only source with no slots still uses focus list
      if Array(entry["focus_spells"]).map { |s| s.to_s.downcase }.include?(slug)
        return magic_cast_focus(sheet, slug, source: resolved[:source], catalog: catalog, base_rank: base_rank)
      end

      cast_rank = resolve_cast_rank(rank, base_rank, catalog)
      if cast_rank.nil?
        return { ok: false, error: "pf2e.magic_unknown_spell", spells: [slug] } if catalog.nil?
        return { ok: false, error: "pf2e.magic_cast_usage" }
      end

      if cast_rank == 0 || cantrip_spell?(catalog, base_rank)
        return magic_cast_cantrip(sheet, resolved[:source], entry, slug, catalog: catalog)
      end

      if cast_rank < (base_rank || 0)
        return {
          ok: false,
          error: "pf2e.magic_rank_too_low",
          spell: slug,
          base_rank: base_rank,
          rank: cast_rank
        }
      end

      unless spell_known_on_source?(entry, slug, casting: casting, base_rank: base_rank, cast_rank: cast_rank)
        return { ok: false, error: "pf2e.magic_not_known", spell: slug, source: resolved[:source] }
      end

      if casting == "prepared" || casting.empty?
        unless prepared_at_rank?(entry, slug, cast_rank)
          return {
            ok: false,
            error: "pf2e.magic_not_prepared_spell",
            spell: slug,
            source: resolved[:source],
            rank: cast_rank
          }
        end
      end

      spent = magic_spend_slot(sheet, resolved[:source], cast_rank)
      return spent unless spent[:ok]

      dc_info = magic_spell_dc(sheet, resolved[:source])
      atk_info = magic_spell_attack_mod(sheet, resolved[:source])

      {
        ok: true,
        mode: casting == "spontaneous" ? "spontaneous" : "prepared",
        source: resolved[:source],
        spell: slug,
        rank: cast_rank,
        base_rank: base_rank,
        heightened: base_rank && cast_rank > base_rank,
        slot_used: spent[:used],
        slot_max: spent[:max],
        dc: dc_info[:ok] ? dc_info[:value] : nil,
        attack: atk_info[:ok] ? atk_info[:value] : nil,
        tradition: entry["tradition"],
        name: catalog.is_a?(Hash) ? (catalog["name"] || slug) : slug
      }
    end

    def self.magic_cast_innate(sheet, slug)
      result = innate_cast(sheet, slug)
      return result unless result[:ok]
      result.merge(
        mode: "innate",
        source: INNATE_SOURCE,
        name: (spell_entry(slug) || {})["name"] || slug,
        heightened: false
      )
    end

    def self.magic_cast_focus(sheet, slug, source:, catalog:, base_rank:)
      ensure_focus_pool_from_spells!(sheet)
      spent = spend_focus(sheet, 1)
      return spent unless spent[:ok]

      dc_info = magic_spell_dc(sheet, source)
      atk_info = magic_spell_attack_mod(sheet, source)
      rank = base_rank.nil? ? (catalog.is_a?(Hash) ? catalog["rank"].to_i : 0) : base_rank

      {
        ok: true,
        mode: "focus",
        source: source,
        spell: slug,
        rank: rank,
        base_rank: rank,
        heightened: false,
        focus_before: spent[:before],
        focus_after: spent[:after],
        focus_max: spent[:max],
        dc: dc_info[:ok] ? dc_info[:value] : nil,
        attack: atk_info[:ok] ? atk_info[:value] : nil,
        name: catalog.is_a?(Hash) ? (catalog["name"] || slug) : slug
      }
    end

    def self.magic_cast_cantrip(sheet, source, entry, slug, catalog:)
      known = Array(entry["cantrips"]).map { |s| s.to_s.downcase }
      prepared = entry["prepared"].is_a?(Hash) ? entry["prepared"] : {}
      prep_cantrips = Array(prepared["cantrip"] || prepared["0"] || prepared[0]).map { |s| s.to_s.downcase }

      unless known.include?(slug) || prep_cantrips.include?(slug)
        return { ok: false, error: "pf2e.magic_not_known", spell: slug, source: source }
      end

      dc_info = magic_spell_dc(sheet, source)
      atk_info = magic_spell_attack_mod(sheet, source)

      {
        ok: true,
        mode: "cantrip",
        source: source,
        spell: slug,
        rank: 0,
        base_rank: 0,
        heightened: false,
        dc: dc_info[:ok] ? dc_info[:value] : nil,
        attack: atk_info[:ok] ? atk_info[:value] : nil,
        tradition: entry["tradition"],
        name: catalog.is_a?(Hash) ? (catalog["name"] || slug) : slug
      }
    end

    def self.resolve_cast_rank(rank_arg, base_rank, catalog)
      if rank_arg.nil? || rank_arg.to_s.strip.empty?
        return 0 if cantrip_spell?(catalog, base_rank)
        return base_rank unless base_rank.nil?
        return nil
      end
      r = rank_arg.to_i
      return nil if r < 0
      r
    end

    def self.cantrip_spell?(catalog, base_rank)
      return true if base_rank == 0
      return false unless catalog.is_a?(Hash)
      traits = Array(catalog["traits"]).map { |t| t.to_s.downcase }
      traits.include?("cantrip") || catalog["category"].to_s.downcase == "cantrip"
    end

    def self.prepared_at_rank?(entry, slug, cast_rank)
      prepared = entry["prepared"]
      return false unless prepared.is_a?(Hash)
      key = cast_rank.to_s
      list = Array(prepared[key] || prepared[cast_rank]).map { |s| s.to_s.downcase }
      list.include?(slug)
    end

    def self.spell_known_on_source?(entry, slug, casting:, base_rank:, cast_rank:)
      slug = slug.to_s.downcase
      return true if Array(entry["cantrips"]).map { |s| s.to_s.downcase }.include?(slug)

      if casting == "spontaneous"
        rep = entry["repertoire"]
        return false unless rep.is_a?(Hash)
        # Known if listed at base rank or any repertoire rank <= cast rank
        keys = rep.keys.map(&:to_s)
        keys.each do |k|
          next if k.to_i > cast_rank.to_i && k.to_i > 0
          list = Array(rep[k] || rep[k.to_i]).map { |s| s.to_s.downcase }
          return true if list.include?(slug)
        end
        # Also allow listing only at base rank while casting heightened
        if base_rank
          list = Array(rep[base_rank.to_s] || rep[base_rank]).map { |s| s.to_s.downcase }
          return true if list.include?(slug)
        end
        return false
      end

      # Prepared: known via spellbook or already prepared somewhere
      book = Array(entry["spellbook"]).map { |s| s.to_s.downcase }
      return true if book.include?(slug)

      prepared = entry["prepared"]
      if prepared.is_a?(Hash)
        prepared.each_value do |list|
          return true if Array(list).map { |s| s.to_s.downcase }.include?(slug)
        end
      end
      false
    end

    # True if any non-innate source knows this slug as cantrip, spellbook, repertoire, or prepared.
    def self.class_known_spell?(char_or_sheet, slug, exclude_focus: false)
      slug = slug.to_s.downcase
      magic_hash(char_or_sheet).any? do |src, entry|
        next false unless entry.is_a?(Hash)
        next false if src.to_s == INNATE_SOURCE || entry["casting"].to_s.downcase == "innate"
        next true if !exclude_focus && Array(entry["focus_spells"]).map { |s| s.to_s.downcase }.include?(slug)
        next true if Array(entry["cantrips"]).map { |s| s.to_s.downcase }.include?(slug)
        next true if Array(entry["spellbook"]).map { |s| s.to_s.downcase }.include?(slug)
        if entry["repertoire"].is_a?(Hash)
          entry["repertoire"].each_value do |list|
            return true if Array(list).map { |s| s.to_s.downcase }.include?(slug)
          end
        end
        if entry["prepared"].is_a?(Hash)
          entry["prepared"].each_value do |list|
            return true if Array(list).map { |s| s.to_s.downcase }.include?(slug)
          end
        end
        false
      end
    end

    def self.format_cast_message(enactor, result)
      name = result[:name] || result[:spell]
      spell = result[:spell]
      source = result[:source]
      dc = result[:dc] || "?"
      atk = result[:attack] || "?"
      rank = result[:rank]

      case result[:mode].to_s
      when "innate"
        if result[:frequency].to_s == "at_will"
          t('pf2e.cast_innate_atwill', :name => enactor.name, :spell => name, :slug => spell,
            :dc => dc, :attack => atk)
        else
          t('pf2e.cast_innate', :name => enactor.name, :spell => name, :slug => spell,
            :used => result[:used], :max => result[:max], :dc => dc, :attack => atk)
        end
      when "focus"
        t('pf2e.cast_focus', :name => enactor.name, :spell => name, :slug => spell,
          :source => source, :rank => rank,
          :fp => result[:focus_after], :fp_max => result[:focus_max],
          :dc => dc, :attack => atk)
      when "cantrip"
        t('pf2e.cast_cantrip', :name => enactor.name, :spell => name, :slug => spell,
          :source => source, :dc => dc, :attack => atk)
      else
        height = result[:heightened] ? t('pf2e.cast_heightened_note', :base => result[:base_rank]) : ""
        t('pf2e.cast_slot', :name => enactor.name, :spell => name, :slug => spell,
          :source => source, :rank => rank, :height => height,
          :used => result[:slot_used], :max => result[:slot_max],
          :dc => dc, :attack => atk)
      end
    end

  end
end

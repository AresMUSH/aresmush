module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Spell items (scrolls, wands, staves)
    #
    # Stored on inventory instances as entry["spell"]:
    #
    # Scroll:
    #   type: scroll
    #   slug, rank, tradition
    #   (consumable; qty decreases; destroyed at 0)
    #
    # Wand:
    #   type: wand
    #   slug, rank, tradition
    #   charges, charges_max (default 1)
    #   daily: true  → restore charges on daily prep
    #
    # Staff:
    #   type: staff
    #   tradition
    #   charges, charges_max
    #   daily: true/false (default true for simplicity)
    #   cantrips: [slug, ...]
    #   spells: [{ slug, rank, cost }, ...]  cost defaults to rank
    #
    # Activation uses the caster's spell DC/attack for a matching
    # tradition source when available; otherwise a flat item DC/attack
    # based on stored rank (no Trick Magic Item automation yet).
    # -------------------------------------------------

    SPELL_ITEM_TYPES = %w[scroll wand staff].freeze

    def self.spell_item_type(entry)
      return nil unless entry.is_a?(Hash)
      sp = entry["spell"]
      if sp.is_a?(Hash) && !sp["type"].to_s.empty?
        t = sp["type"].to_s.downcase
        return t if SPELL_ITEM_TYPES.include?(t)
      end
      kind = entry["kind"].to_s.downcase
      return kind if SPELL_ITEM_TYPES.include?(kind)
      nil
    end

    def self.spell_item?(entry)
      !spell_item_type(entry).nil?
    end

    def self.normalize_spell_payload(raw, type: nil)
      return nil unless raw.is_a?(Hash) || type
      sp = raw.is_a?(Hash) ? raw.dup : {}
      t = (type || sp["type"] || sp[:type]).to_s.downcase
      return nil unless SPELL_ITEM_TYPES.include?(t)

      out = { "type" => t }
      out["slug"] = (sp["slug"] || sp[:slug]).to_s.strip.downcase if sp["slug"] || sp[:slug]
      out["slug"] = nil if out["slug"].to_s.empty?

      rank = sp["rank"] || sp[:rank]
      out["rank"] = rank.nil? ? nil : rank.to_i

      trad = (sp["tradition"] || sp[:tradition]).to_s.strip.downcase
      out["tradition"] = trad.empty? ? nil : trad

      case t
      when "scroll"
        # single-spell consumable
      when "wand"
        max = (sp["charges_max"] || sp[:charges_max] || 1).to_i
        max = 1 if max < 1
        cur = sp.key?("charges") || sp.key?(:charges) ? (sp["charges"] || sp[:charges]).to_i : max
        out["charges_max"] = max
        out["charges"] = [[cur, 0].max, max].min
        out["daily"] = sp.key?("daily") || sp.key?(:daily) ? !!(sp["daily"] || sp[:daily]) : true
      when "staff"
        max = (sp["charges_max"] || sp[:charges_max] || 5).to_i
        max = 1 if max < 1
        cur = sp.key?("charges") || sp.key?(:charges) ? (sp["charges"] || sp[:charges]).to_i : max
        out["charges_max"] = max
        out["charges"] = [[cur, 0].max, max].min
        out["daily"] = sp.key?("daily") || sp.key?(:daily) ? !!(sp["daily"] || sp[:daily]) : true
        out["cantrips"] = Array(sp["cantrips"] || sp[:cantrips]).map { |s| s.to_s.strip.downcase }.reject(&:empty?)
        spells = []
        Array(sp["spells"] || sp[:spells]).each do |row|
          next unless row.is_a?(Hash)
          slug = (row["slug"] || row[:slug]).to_s.strip.downcase
          next if slug.empty?
          rnk = (row["rank"] || row[:rank] || 1).to_i
          cost = (row["cost"] || row[:cost] || rnk).to_i
          cost = 1 if cost < 1
          spells << { "slug" => slug, "rank" => rnk, "cost" => cost }
        end
        out["spells"] = spells
        # Convenience: single primary spell on a simple staff
        if out["slug"] && spells.none? { |row| row["slug"] == out["slug"] }
          rnk = out["rank"] || 1
          out["spells"] << { "slug" => out["slug"], "rank" => rnk, "cost" => rnk }
        end
      end
      out
    end

    def self.spell_payload_from_catalog(cat)
      return nil unless cat.is_a?(Hash)
      raw = cat["spell"] || cat["spell_item"]
      type = cat["kind"].to_s.downcase if SPELL_ITEM_TYPES.include?(cat["kind"].to_s.downcase)
      normalize_spell_payload(raw.is_a?(Hash) ? raw : {}, type: type || (raw.is_a?(Hash) ? raw["type"] : nil))
    end

    # Flat DC/attack when the caster has no matching tradition source.
    # Rough item math: trained-ish DC at the stored rank.
    def self.spell_item_flat_dc(rank)
      r = [rank.to_i, 0].max
      10 + r + (r + 1) # 10 + rank + (rank+1) ≈ moderate progressive DC
    end

    def self.spell_item_flat_attack(rank)
      spell_item_flat_dc(rank) - 10
    end

    def self.spell_item_resolve_stats(char_or_sheet, tradition, rank)
      sheet = sheet_for(char_or_sheet)
      trad = tradition.to_s.strip.downcase

      if sheet && !trad.empty?
        magic_sources(sheet).each do |src|
          next if src == "innate"
          entry = magic_source(sheet, src)
          next unless entry.is_a?(Hash)
          next if entry["casting"].to_s.downcase == "innate"
          et = entry["tradition"].to_s.downcase
          next unless et.empty? || et == trad

          dc_info = magic_spell_dc(sheet, src)
          atk_info = magic_spell_attack_mod(sheet, src)
          if dc_info[:ok] && atk_info[:ok]
            return {
              dc: dc_info[:value],
              attack: atk_info[:value],
              source: src,
              using_caster: true,
              tradition: trad
            }
          end
        end
      end

      {
        dc: spell_item_flat_dc(rank),
        attack: spell_item_flat_attack(rank),
        source: nil,
        using_caster: false,
        tradition: trad.empty? ? nil : trad
      }
    end

    def self.find_staff_spell_option(spell_payload, spell_slug)
      slug = spell_slug.to_s.strip.downcase
      return nil if slug.empty?
      Array(spell_payload["cantrips"]).each do |c|
        return { "slug" => c, "rank" => 0, "cost" => 0 } if c == slug
      end
      Array(spell_payload["spells"]).find { |row| row["slug"] == slug }
    end

    # Activate / Cast from a spell item.
    # spell_slug required for staff when multiple spells; optional otherwise.
    def self.spell_item_activate(char_or_sheet, item_id, spell_slug: nil)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      item = find_item(sheet, item_id)
      return { ok: false, error: "pf2e.item_not_found" } unless item
      return { ok: false, error: "pf2e.spell_item_not" } unless spell_item?(item)
      return { ok: false, error: "pf2e.spell_item_stowed" } if item["contained_in"].to_s.strip != ""

      sp = normalize_spell_payload(item["spell"] || {}, type: spell_item_type(item))
      return { ok: false, error: "pf2e.spell_item_bad" } unless sp

      type = sp["type"]
      chosen_slug = nil
      chosen_rank = nil
      cost = 0

      case type
      when "scroll", "wand"
        chosen_slug = sp["slug"]
        chosen_rank = sp["rank"].to_i
        return { ok: false, error: "pf2e.spell_item_bad" } if chosen_slug.to_s.empty?
        if spell_slug && !spell_slug.to_s.strip.empty? && spell_slug.to_s.strip.downcase != chosen_slug
          return { ok: false, error: "pf2e.spell_item_wrong_spell", spell: chosen_slug }
        end
        cost = 1
      when "staff"
        want = spell_slug.to_s.strip.downcase
        want = sp["slug"].to_s if want.empty? && sp["slug"]
        if want.empty?
          options = Array(sp["cantrips"]) + Array(sp["spells"]).map { |r| r["slug"] }
          return {
            ok: false,
            error: "pf2e.spell_item_staff_need_spell",
            options: options
          }
        end
        opt = find_staff_spell_option(sp, want)
        return { ok: false, error: "pf2e.spell_item_staff_unknown", spell: want } unless opt
        chosen_slug = opt["slug"]
        chosen_rank = opt["rank"].to_i
        cost = opt["cost"].to_i
      end

      # Charge / consume checks
      case type
      when "scroll"
        # qty check only
      when "wand", "staff"
        charges = sp["charges"].to_i
        if cost > 0 && charges < cost
          return {
            ok: false,
            error: "pf2e.spell_item_no_charges",
            charges: charges,
            needed: cost,
            max: sp["charges_max"].to_i
          }
        end
      end

      stats = spell_item_resolve_stats(sheet, sp["tradition"], chosen_rank)

      # Apply spend
      list = sheet_inventory(sheet)
      idx = list.index { |e| e["id"].to_s.downcase == item["id"].to_s.downcase }
      return { ok: false, error: "pf2e.item_not_found" } unless idx
      entry = list[idx].dup
      consumed = false
      charges_left = nil

      case type
      when "scroll"
        qty = entry["qty"].to_i
        if qty <= 1
          list.delete_at(idx)
          consumed = true
          charges_left = 0
        else
          entry["qty"] = qty - 1
          list[idx] = normalize_item(entry)
          charges_left = entry["qty"]
        end
      when "wand", "staff"
        payload = normalize_spell_payload(entry["spell"] || {}, type: type)
        payload["charges"] = payload["charges"].to_i - cost
        payload["charges"] = 0 if payload["charges"] < 0
        entry["spell"] = payload
        entry["unique"] = true
        list[idx] = normalize_item(entry)
        charges_left = payload["charges"]
      end

      save_inventory(sheet, list)
      updated = consumed ? nil : find_item(sheet, item["id"])

      {
        ok: true,
        error: nil,
        type: type,
        item_id: item["id"],
        item_name: item_display_name(item),
        spell: chosen_slug,
        rank: chosen_rank,
        tradition: sp["tradition"],
        cost: cost,
        consumed: consumed,
        charges: charges_left,
        charges_max: sp["charges_max"],
        dc: stats[:dc],
        attack: stats[:attack],
        using_caster: stats[:using_caster],
        source: stats[:source],
        item: updated
      }
    end

    def self.spell_item_restore_daily!(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      list = sheet_inventory(sheet)
      changed = 0
      list.each_with_index do |entry, idx|
        next unless spell_item?(entry)
        sp = normalize_spell_payload(entry["spell"] || {}, type: spell_item_type(entry))
        next unless sp
        next unless %w[wand staff].include?(sp["type"])
        next unless sp["daily"]
        max = sp["charges_max"].to_i
        next if sp["charges"].to_i >= max
        sp["charges"] = max
        e = entry.dup
        e["spell"] = sp
        list[idx] = normalize_item(e)
        changed += 1
      end
      save_inventory(sheet, list) if changed > 0
      { ok: true, restored: changed }
    end

    def self.inventory_add_spell_item(char_or_sheet, type:, spell:, rank: nil, tradition: nil,
                                      name: nil, charges_max: nil, charges: nil, daily: true,
                                      cantrips: nil, spells: nil, qty: 1, bulk: "L",
                                      society: false, notes: nil, slug: nil)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      t = type.to_s.downcase
      return { ok: false, error: "pf2e.spell_item_bad_type" } unless SPELL_ITEM_TYPES.include?(t)

      payload = {
        "type" => t,
        "slug" => spell.to_s.strip.downcase,
        "rank" => rank.nil? ? nil : rank.to_i,
        "tradition" => tradition
      }
      case t
      when "wand"
        payload["charges_max"] = charges_max || 1
        payload["charges"] = charges || payload["charges_max"]
        payload["daily"] = daily
      when "staff"
        payload["charges_max"] = charges_max || 5
        payload["charges"] = charges || payload["charges_max"]
        payload["daily"] = daily
        payload["cantrips"] = cantrips || []
        payload["spells"] = spells || []
      end
      payload = normalize_spell_payload(payload, type: t)
      return { ok: false, error: "pf2e.spell_item_bad" } unless payload

      display = name.to_s.strip
      if display.empty?
        spname = payload["slug"].to_s.tr("_", " ").split.map(&:capitalize).join(" ")
        display = case t
                  when "scroll" then "Scroll of #{spname}" + (payload["rank"] ? " (#{payload['rank']})" : "")
                  when "wand" then "Wand of #{spname}" + (payload["rank"] ? " (#{payload['rank']})" : "")
                  when "staff" then (spname.empty? ? "Staff" : "Staff of #{spname}")
                  else t.capitalize
                  end
      end

      unique = t != "scroll"
      inventory_add(char_or_sheet,
                    slug: slug,
                    kind: t,
                    name: display,
                    qty: unique ? 1 : qty,
                    bulk: bulk,
                    unique: unique,
                    society: society,
                    notes: notes || "",
                    spell: payload)
    end

    def self.format_spell_item_brief(entry)
      return nil unless spell_item?(entry)
      sp = normalize_spell_payload(entry["spell"] || {}, type: spell_item_type(entry))
      return nil unless sp
      case sp["type"]
      when "scroll"
        "scroll #{sp['slug']} R#{sp['rank']}"
      when "wand"
        "wand #{sp['slug']} R#{sp['rank']} #{sp['charges']}/#{sp['charges_max']}ch"
      when "staff"
        bits = Array(sp["cantrips"]) + Array(sp["spells"]).map { |r| "#{r['slug']}R#{r['rank']}" }
        "staff #{sp['charges']}/#{sp['charges_max']}ch [#{bits.join(', ')}]"
      else
        sp["type"]
      end
    end

  end
end

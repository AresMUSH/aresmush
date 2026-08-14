module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Inventory
    #
    # Each entry is an *instance* hash:
    #   id           — unique instance id ("i12")
    #   slug         — catalog key or nil for pure custom
    #   kind         — weapon | armor | shield | gear | consumable | alchemical | custom
    #   name         — display name
    #   qty          — stack size (1 if unique)
    #   bulk         — override; else from catalog
    #   equipped     — worn/wielded
    #   contained_in — container instance id, or nil/empty if carried
    #   unique       — magic, runed, or one-off
    #   society      — Hall issued/brokered (cannot be stowed)
    #   runes / magic / notes / price_cp
    # -------------------------------------------------

    ITEM_KINDS = %w[weapon armor shield gear consumable alchemical custom].freeze

    def self.next_item_id(sheet)
      seq = sheet.item_seq.to_i + 1
      sheet.update(item_seq: seq)
      "i#{seq}"
    end

    def self.sheet_inventory(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      return [] unless sheet
      Array(sheet.inventory).map { |e| e.is_a?(Hash) ? e.dup : nil }.compact
    end

    def self.find_item(char_or_sheet, item_id)
      id = item_id.to_s.strip.downcase
      sheet_inventory(char_or_sheet).find { |e| e["id"].to_s.downcase == id }
    end

    def self.catalog_entry(kind, slug)
      return nil if slug.nil? || slug.to_s.strip.empty?
      key = slug.to_s.strip.downcase
      case kind.to_s
      when "weapon" then read_data("weapons", key)
      when "armor", "shield" then read_data("armor", key) || read_data("items", key)
      else read_data("items", key) || read_data("weapons", key) || read_data("armor", key)
      end
    end

    def self.infer_kind_from_slug(slug)
      key = slug.to_s.strip.downcase
      return "weapon" if read_data("weapons", key)
      arm = read_data("armor", key)
      if arm.is_a?(Hash)
        return arm["kind"].to_s == "shield" ? "shield" : "armor"
      end
      entry = read_data("items", key)
      return entry["kind"].to_s if entry.is_a?(Hash) && entry["kind"]
      "gear"
    end

    def self.slug_in_catalog?(slug)
      key = slug.to_s.strip.downcase
      return false if key.empty?
      !!(read_data("weapons", key) || read_data("armor", key) || read_data("items", key))
    end

    def self.item_is_unique?(entry)
      return true if entry["unique"]
      runes = entry["runes"]
      if runes.is_a?(Hash)
        return true if runes["potency"].to_i > 0
        return true if runes["striking"].to_i > 0
        return true if runes["resilient"].to_i > 0
        return true if Array(runes["property"]).any?
      end
      magic = entry["magic"]
      return true if magic.is_a?(Hash) && !magic.empty?
      false
    end

    def self.item_display_name(entry)
      return entry["name"] if entry["name"].to_s.strip != ""
      slug = entry["slug"].to_s
      cat = catalog_entry(entry["kind"], slug)
      return cat["name"] if cat.is_a?(Hash) && cat["name"]
      slug.empty? ? entry["id"].to_s : slug
    end

    def self.format_runes_brief(entry)
      runes = entry["runes"]
      return nil unless runes.is_a?(Hash) && !runes.empty?
      bits = []
      bits << "+#{runes["potency"]}" if runes["potency"].to_i > 0
      bits << "striking#{runes["striking"].to_i > 1 ? runes["striking"].to_i : ''}" if runes["striking"].to_i > 0
      bits << "resilient#{runes["resilient"].to_i > 1 ? runes["resilient"].to_i : ''}" if runes["resilient"].to_i > 0
      Array(runes["property"]).each { |p| bits << p.to_s }
      bits.empty? ? nil : bits.join(", ")
    end

    def self.format_item_line(entry)
      name = item_display_name(entry)
      qty = entry["qty"].to_i
      qty_bit = qty > 1 ? " x#{qty}" : ""
      bulk = format_bulk(item_effective_bulk(entry))
      kind = entry["kind"].to_s
      rune_bit = format_runes_brief(entry)
      rune_bit = rune_bit ? " [#{rune_bit}]" : ""
      unique_bit = entry["unique"] ? " *" : ""
      soc_bit = entry["society"] ? " %x[Society]%xn" : ""
      stow_bit = if entry["contained_in"].to_s.strip != ""
                   " %xin #{entry['contained_in']}%xn"
                 else
                   ""
                 end
      "%xh#{entry['id']}%xn  #{name}#{qty_bit}#{rune_bit}#{unique_bit}#{soc_bit}#{stow_bit}  (#{kind}, Bulk #{bulk})"
    end

    def self.item_unit_bulk(entry)
      if !entry["bulk"].nil? && entry["bulk"].to_s != ""
        return entry["bulk"]
      end
      cat = catalog_entry(entry["kind"], entry["slug"])
      return cat["bulk"] if cat.is_a?(Hash) && !cat["bulk"].nil?
      0
    end

    def self.normalize_item(raw)
      e = {}
      e["id"] = raw["id"].to_s.downcase
      e["slug"] = raw["slug"] ? raw["slug"].to_s.strip.downcase : nil
      e["kind"] = (raw["kind"] || "gear").to_s.strip.downcase
      e["kind"] = "gear" unless ITEM_KINDS.include?(e["kind"])
      e["name"] = raw["name"] ? raw["name"].to_s : nil
      e["qty"] = [raw["qty"].to_i, 1].max
      e["bulk"] = raw.key?("bulk") ? raw["bulk"] : nil
      e["equipped"] = !!raw["equipped"]
      cin = raw["contained_in"].to_s.strip.downcase
      e["contained_in"] = cin.empty? ? nil : cin
      e["runes"] = raw["runes"].is_a?(Hash) ? raw["runes"] : {}
      e["magic"] = raw["magic"].is_a?(Hash) ? raw["magic"] : {}
      e["notes"] = raw["notes"].to_s
      e["price_cp"] = raw["price_cp"]
      e["society"] = !!raw["society"]
      e["unique"] = raw.key?("unique") ? !!raw["unique"] : item_is_unique?(e)
      e["qty"] = 1 if e["unique"]
      e
    end

    def self.save_inventory(sheet, list)
      sheet.update(inventory: list.map { |e| normalize_item(e) })
      sheet_inventory(sheet)
    end

    def self.inventory_add(char_or_sheet, opts = {})
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      slug = opts[:slug] || opts["slug"]
      kind = (opts[:kind] || opts["kind"] || (slug ? infer_kind_from_slug(slug) : "custom")).to_s
      qty = (opts[:qty] || opts["qty"] || 1).to_i
      qty = 1 if qty < 1

      raw = {
        "id" => next_item_id(sheet),
        "slug" => slug,
        "kind" => kind,
        "name" => opts[:name] || opts["name"],
        "qty" => qty,
        "bulk" => opts[:bulk] || opts["bulk"],
        "equipped" => opts[:equipped] || opts["equipped"] || false,
        "contained_in" => nil,
        "runes" => opts[:runes] || opts["runes"] || {},
        "magic" => opts[:magic] || opts["magic"] || {},
        "notes" => opts[:notes] || opts["notes"] || "",
        "price_cp" => opts[:price_cp] || opts["price_cp"],
        "unique" => opts[:unique] || opts["unique"],
        "society" => opts[:society] || opts["society"]
      }
      item = normalize_item(raw)

      list = sheet_inventory(sheet)
      unless item["unique"]
        existing = list.find do |e|
          !e["unique"] &&
            e["slug"] == item["slug"] &&
            e["kind"] == item["kind"] &&
            e["name"] == item["name"] &&
            !e["equipped"] && !item["equipped"] &&
            e["contained_in"].to_s.empty? &&
            !!e["society"] == !!item["society"] &&
            (e["runes"] || {}) == (item["runes"] || {}) &&
            (e["magic"] || {}) == (item["magic"] || {})
        end
        if existing
          existing["qty"] = existing["qty"].to_i + item["qty"]
          save_inventory(sheet, list)
          return { ok: true, error: nil, item: existing, inventory: sheet_inventory(sheet) }
        end
      end

      list << item
      save_inventory(sheet, list)
      { ok: true, error: nil, item: item, inventory: sheet_inventory(sheet) }
    end

    def self.inventory_add_from_catalog(char_or_sheet, slug, qty: 1, society: false)
      key = slug.to_s.strip.downcase
      return { ok: false, error: "pf2e.item_unknown_slug" } unless slug_in_catalog?(key)

      kind = infer_kind_from_slug(key)
      cat = catalog_entry(kind, key)
      name = cat.is_a?(Hash) ? cat["name"] : nil
      bulk = cat.is_a?(Hash) ? cat["bulk"] : nil

      inventory_add(char_or_sheet,
                    slug: key, kind: kind, qty: qty, name: name, bulk: bulk,
                    society: society)
    end

    def self.inventory_add_custom(char_or_sheet, opts = {})
      name = (opts[:name] || opts["name"]).to_s.strip
      return { ok: false, error: "pf2e.item_need_name" } if name.empty?

      kind = (opts[:kind] || opts["kind"] || "custom").to_s.downcase
      kind = "custom" unless ITEM_KINDS.include?(kind)

      inventory_add(char_or_sheet,
                    slug: opts[:slug] || opts["slug"],
                    kind: kind,
                    name: name,
                    qty: 1,
                    bulk: opts[:bulk] || opts["bulk"],
                    runes: opts[:runes] || opts["runes"] || {},
                    magic: opts[:magic] || opts["magic"] || {},
                    notes: opts[:notes] || opts["notes"] || "",
                    unique: true,
                    society: opts.fetch(:society, true))
    end

    def self.inventory_remove(char_or_sheet, item_id, qty: nil)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      list = sheet_inventory(sheet)
      id = item_id.to_s.strip.downcase
      idx = list.index { |e| e["id"].to_s.downcase == id }
      return { ok: false, error: "pf2e.item_not_found" } unless idx

      entry = list[idx]
      if qty.nil? || entry["unique"] || qty.to_i >= entry["qty"].to_i
        removed = list.delete_at(idx)
      else
        n = qty.to_i
        return { ok: false, error: "pf2e.item_bad_qty" } if n < 1
        entry["qty"] = entry["qty"].to_i - n
        removed = entry.dup
        removed["qty"] = n
      end
      save_inventory(sheet, list)
      { ok: true, error: nil, item: removed, inventory: sheet_inventory(sheet) }
    end

    def self.inventory_equip(char_or_sheet, item_id, equipped: true)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      list = sheet_inventory(sheet)
      id = item_id.to_s.strip.downcase
      entry = list.find { |e| e["id"].to_s.downcase == id }
      return { ok: false, error: "pf2e.item_not_found" } unless entry

      if equipped && entry["contained_in"].to_s.strip != ""
        return { ok: false, error: "pf2e.equip_stowed" }
      end

      if equipped
        if entry["kind"] == "armor"
          list.each { |e| e["equipped"] = false if e["kind"] == "armor" && e["id"] != entry["id"] }
        elsif entry["kind"] == "shield"
          list.each { |e| e["equipped"] = false if e["kind"] == "shield" && e["id"] != entry["id"] }
        end
      end

      entry["equipped"] = !!equipped
      save_inventory(sheet, list)
      { ok: true, error: nil, item: entry, inventory: sheet_inventory(sheet) }
    end

    def self.inventory_set_runes(char_or_sheet, item_id, runes_hash)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      list = sheet_inventory(sheet)
      id = item_id.to_s.strip.downcase
      entry = list.find { |e| e["id"].to_s.downcase == id }
      return { ok: false, error: "pf2e.item_not_found" } unless entry

      current = entry["runes"].is_a?(Hash) ? entry["runes"].dup : {}
      merge = runes_hash.is_a?(Hash) ? runes_hash : {}
      if merge["property"]
        props = Array(current["property"]) + Array(merge["property"])
        merge = merge.dup
        merge["property"] = props.map(&:to_s).uniq
      end
      entry["runes"] = current.merge(merge)
      entry["unique"] = true
      entry["qty"] = 1
      save_inventory(sheet, list)
      { ok: true, error: nil, item: entry, inventory: sheet_inventory(sheet) }
    end

    def self.inventory_set_magic(char_or_sheet, item_id, magic_hash, replace: false)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      list = sheet_inventory(sheet)
      id = item_id.to_s.strip.downcase
      entry = list.find { |e| e["id"].to_s.downcase == id }
      return { ok: false, error: "pf2e.item_not_found" } unless entry

      incoming = magic_hash.is_a?(Hash) ? magic_hash : {}
      entry["magic"] = if replace
                         incoming
                       else
                         (entry["magic"].is_a?(Hash) ? entry["magic"] : {}).merge(incoming)
                       end
      entry["unique"] = true if entry["magic"] && !entry["magic"].empty?
      entry["qty"] = 1 if entry["unique"]
      save_inventory(sheet, list)
      { ok: true, error: nil, item: entry, inventory: sheet_inventory(sheet) }
    end

    def self.inventory_set_notes(char_or_sheet, item_id, notes)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      list = sheet_inventory(sheet)
      id = item_id.to_s.strip.downcase
      entry = list.find { |e| e["id"].to_s.downcase == id }
      return { ok: false, error: "pf2e.item_not_found" } unless entry

      entry["notes"] = notes.to_s
      save_inventory(sheet, list)
      { ok: true, error: nil, item: entry, inventory: sheet_inventory(sheet) }
    end

    def self.parse_item_kv_tokens(tokens)
      runes = {}
      magic = {}
      meta = {}
      Array(tokens).each do |tok|
        next if tok.nil? || tok.to_s.strip.empty?
        k, v = tok.to_s.split(":", 2)
        next if k.nil? || v.nil?
        key = k.strip.downcase
        val = v.strip
        case key
        when "potency", "striking", "resilient"
          runes[key] = val.to_i
        when "property", "prop"
          runes["property"] ||= []
          runes["property"] << val.downcase
        when "bulk"
          meta["bulk"] = val
        when "qty", "quantity"
          meta["qty"] = val.to_i
        when "notes", "note"
          meta["notes"] = val.tr("_", " ")
        when "slug"
          meta["slug"] = val.downcase
        when "kind"
          meta["kind"] = val.downcase
        else
          magic[key] = val
        end
      end
      { runes: runes, magic: magic, meta: meta }
    end

    def self.equipped_items(char_or_sheet, kind: nil)
      list = sheet_inventory(char_or_sheet).select { |e| e["equipped"] }
      list = list.select { |e| e["kind"] == kind.to_s } if kind
      list
    end

  end
end

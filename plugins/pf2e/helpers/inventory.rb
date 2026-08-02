module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Inventory
    #
    # Each entry is an *instance* hash:
    #   id         — unique instance id ("i12")
    #   slug       — catalog key (weapons/armor/items) or nil for pure custom
    #   kind       — weapon | armor | shield | gear | consumable | custom
    #   name       — display name (override or from catalog)
    #   qty        — stack size (always 1 if unique/magic/runed)
    #   bulk       — string/number override; else from catalog
    #   equipped   — worn/wielded
    #   unique     — true for magic, runed, or one-off named items
    #   runes      — { "potency"=>1, "striking"=>1, "resilient"=>0,
    #                  "property"=>["flaming"] } (weapons/armor as applicable)
    #   magic      — freeform hash for innate magic item data
    #   notes      — player/staff string
    #   price_cp   — optional residual value in copper
    #
    # Catalog lookups:
    #   weapons.yml → kind weapon
    #   armor.yml   → kind armor
    #   items.yml   → kind gear/consumable/etc.
    # -------------------------------------------------

    ITEM_KINDS = %w[weapon armor shield gear consumable custom].freeze

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
      id = item_id.to_s.strip
      sheet_inventory(char_or_sheet).find { |e| e["id"].to_s == id }
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
      return "armor" if read_data("armor", key)
      entry = read_data("items", key)
      return entry["kind"].to_s if entry.is_a?(Hash) && entry["kind"]
      "gear"
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

    # Resolve bulk string/number for one instance (qty applied by caller for stacks).
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
      e["id"] = raw["id"].to_s
      e["slug"] = raw["slug"] ? raw["slug"].to_s.strip.downcase : nil
      e["kind"] = (raw["kind"] || "gear").to_s.strip.downcase
      e["kind"] = "gear" unless ITEM_KINDS.include?(e["kind"])
      e["name"] = raw["name"] ? raw["name"].to_s : nil
      e["qty"] = [raw["qty"].to_i, 1].max
      e["bulk"] = raw.key?("bulk") ? raw["bulk"] : nil
      e["equipped"] = !!raw["equipped"]
      e["runes"] = raw["runes"].is_a?(Hash) ? raw["runes"] : {}
      e["magic"] = raw["magic"].is_a?(Hash) ? raw["magic"] : {}
      e["notes"] = raw["notes"].to_s
      e["price_cp"] = raw["price_cp"]
      e["unique"] = raw.key?("unique") ? !!raw["unique"] : item_is_unique?(e)
      e["qty"] = 1 if e["unique"]
      e
    end

    def self.save_inventory(sheet, list)
      sheet.update(inventory: list.map { |e| normalize_item(e) })
      sheet_inventory(sheet)
    end

    # Add from catalog or fully custom. Forces unique when runes/magic present.
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
        "runes" => opts[:runes] || opts["runes"] || {},
        "magic" => opts[:magic] || opts["magic"] || {},
        "notes" => opts[:notes] || opts["notes"] || "",
        "price_cp" => opts[:price_cp] || opts["price_cp"],
        "unique" => opts[:unique] || opts["unique"]
      }
      item = normalize_item(raw)

      # Stack identical non-unique catalog items
      list = sheet_inventory(sheet)
      unless item["unique"]
        existing = list.find do |e|
          !e["unique"] &&
            e["slug"] == item["slug"] &&
            e["kind"] == item["kind"] &&
            e["name"] == item["name"] &&
            !e["equipped"] && !item["equipped"] &&
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

    def self.inventory_remove(char_or_sheet, item_id, qty: nil)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      list = sheet_inventory(sheet)
      idx = list.index { |e| e["id"].to_s == item_id.to_s }
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
      entry = list.find { |e| e["id"].to_s == item_id.to_s }
      return { ok: false, error: "pf2e.item_not_found" } unless entry

      entry["equipped"] = !!equipped
      save_inventory(sheet, list)
      { ok: true, error: nil, item: entry, inventory: sheet_inventory(sheet) }
    end

    # Apply or update runes — forces unique and qty 1.
    def self.inventory_set_runes(char_or_sheet, item_id, runes_hash)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      list = sheet_inventory(sheet)
      entry = list.find { |e| e["id"].to_s == item_id.to_s }
      return { ok: false, error: "pf2e.item_not_found" } unless entry

      entry["runes"] = runes_hash.is_a?(Hash) ? runes_hash : {}
      entry["unique"] = true
      entry["qty"] = 1
      save_inventory(sheet, list)
      { ok: true, error: nil, item: entry, inventory: sheet_inventory(sheet) }
    end

    def self.inventory_set_magic(char_or_sheet, item_id, magic_hash)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      list = sheet_inventory(sheet)
      entry = list.find { |e| e["id"].to_s == item_id.to_s }
      return { ok: false, error: "pf2e.item_not_found" } unless entry

      entry["magic"] = magic_hash.is_a?(Hash) ? magic_hash : {}
      entry["unique"] = true if entry["magic"] && !entry["magic"].empty?
      entry["qty"] = 1 if entry["unique"]
      save_inventory(sheet, list)
      { ok: true, error: nil, item: entry, inventory: sheet_inventory(sheet) }
    end

    def self.equipped_items(char_or_sheet, kind: nil)
      list = sheet_inventory(char_or_sheet).select { |e| e["equipped"] }
      list = list.select { |e| e["kind"] == kind.to_s } if kind
      list
    end

  end
end

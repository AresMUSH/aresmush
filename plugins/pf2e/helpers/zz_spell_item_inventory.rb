module AresMUSH
  module Pf2e

    # Loads after inventory.rb / magic hooks.

    remove_const(:ITEM_KINDS) if const_defined?(:ITEM_KINDS, false)
    ITEM_KINDS = %w[weapon armor shield gear consumable alchemical custom scroll wand staff].freeze

    class << self
      unless method_defined?(:normalize_item_without_spell)
        alias_method :normalize_item_without_spell, :normalize_item
      end
      unless method_defined?(:format_item_line_without_spell)
        alias_method :format_item_line_without_spell, :format_item_line
      end
      unless method_defined?(:inventory_add_without_spell)
        alias_method :inventory_add_without_spell, :inventory_add
      end
      unless method_defined?(:inventory_add_from_catalog_without_spell)
        alias_method :inventory_add_from_catalog_without_spell, :inventory_add_from_catalog
      end
      unless method_defined?(:item_is_unique_without_spell)
        alias_method :item_is_unique_without_spell, :item_is_unique?
      end
      unless method_defined?(:magic_daily_reset_without_spell_items)
        alias_method :magic_daily_reset_without_spell_items, :magic_daily_reset
      end
    end

    def self.item_is_unique?(entry)
      return true if spell_item_type(entry) && spell_item_type(entry) != "scroll"
      item_is_unique_without_spell(entry)
    end

    def self.normalize_item(raw)
      e = normalize_item_without_spell(raw)
      sp_raw = raw["spell"] || raw[:spell]
      if sp_raw.is_a?(Hash) || SPELL_ITEM_TYPES.include?(e["kind"].to_s)
        type_hint = e["kind"] if SPELL_ITEM_TYPES.include?(e["kind"].to_s)
        sp = normalize_spell_payload(sp_raw.is_a?(Hash) ? sp_raw : {}, type: type_hint)
        if sp
          e["spell"] = sp
          e["kind"] = sp["type"] if SPELL_ITEM_TYPES.include?(sp["type"])
          e["unique"] = true if sp["type"] != "scroll"
          e["qty"] = 1 if e["unique"]
        end
      end
      e
    end

    def self.format_item_line(entry)
      line = format_item_line_without_spell(entry)
      brief = format_spell_item_brief(entry)
      return line unless brief
      line.sub(/\((#{Regexp.escape(entry['kind'].to_s)}, Bulk)/, "(#{brief}; \\1")
    rescue
      line
    end

    def self.inventory_add(char_or_sheet, opts = {})
      # Allow spell: hash through to normalize_item
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      if opts[:spell] || opts["spell"]
        slug = opts[:slug] || opts["slug"]
        kind = (opts[:kind] || opts["kind"] || (slug ? infer_kind_from_slug(slug) : "custom")).to_s
        sp = normalize_spell_payload(opts[:spell] || opts["spell"], type: kind)
        kind = sp["type"] if sp && SPELL_ITEM_TYPES.include?(sp["type"])

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
          "spell" => sp,
          "notes" => opts[:notes] || opts["notes"] || "",
          "price_cp" => opts[:price_cp] || opts["price_cp"],
          "unique" => opts.key?(:unique) || opts.key?("unique") ? (opts[:unique] || opts["unique"]) : nil,
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
              (e["runes"] || {}) == (item["runes"] || {}) &&
              (e["magic"] || {}) == (item["magic"] || {}) &&
              (e["spell"] || {}) == (item["spell"] || {}) &&
              e["society"] == item["society"] &&
              e["contained_in"].to_s == ""
          end
          if existing
            existing["qty"] = existing["qty"].to_i + item["qty"].to_i
            save_inventory(sheet, list)
            return { ok: true, error: nil, item: find_item(sheet, existing["id"]), inventory: sheet_inventory(sheet) }
          end
        end

        list << item
        save_inventory(sheet, list)
        { ok: true, error: nil, item: item, inventory: sheet_inventory(sheet) }
      else
        inventory_add_without_spell(char_or_sheet, opts)
      end
    end

    def self.inventory_add_from_catalog(char_or_sheet, slug, qty: 1, society: false)
      key = slug.to_s.strip.downcase
      return { ok: false, error: "pf2e.item_unknown_slug" } unless slug_in_catalog?(key)

      kind = infer_kind_from_slug(key)
      cat = catalog_entry(kind, key)
      name = cat.is_a?(Hash) ? cat["name"] : nil
      bulk = cat.is_a?(Hash) ? cat["bulk"] : nil
      spell = spell_payload_from_catalog(cat)

      if spell
        inventory_add(char_or_sheet,
                      slug: key, kind: spell["type"] || kind, qty: qty, name: name, bulk: bulk,
                      society: society, spell: spell,
                      unique: spell["type"] != "scroll")
      else
        inventory_add_from_catalog_without_spell(char_or_sheet, slug, qty: qty, society: society)
      end
    end

    def self.infer_kind_from_slug(slug)
      key = slug.to_s.strip.downcase
      entry = read_data("items", key)
      if entry.is_a?(Hash) && entry["kind"]
        k = entry["kind"].to_s.downcase
        return k if ITEM_KINDS.include?(k)
      end
      return "weapon" if read_data("weapons", key)
      arm = read_data("armor", key)
      if arm.is_a?(Hash)
        return arm["kind"].to_s == "shield" ? "shield" : "armor"
      end
      "gear"
    end

    def self.magic_daily_reset(char_or_sheet, restore_focus: true)
      r = magic_daily_reset_without_spell_items(char_or_sheet, restore_focus: restore_focus)
      return r unless r[:ok]
      wand = spell_item_restore_daily!(char_or_sheet)
      r.merge(spell_items_restored: wand[:restored].to_i)
    end

  end
end

module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Vendors (mundane gear)
    # Buy/sell from purse only — Society account must be withdrawn first.
    # Catalog prices in silver pieces (sp).
    # Sell-back: half catalog price (floor), society/unique/runed not sold here.
    # -------------------------------------------------

    SELL_RATE = 0.5

    def self.vendor_list
      data = read_data("vendors") || {}
      data.keys.sort
    end

    def self.vendor_entry(slug)
      key = slug.to_s.strip.downcase
      return nil if key.empty?
      read_data("vendors", key)
    end

    def self.catalog_price_sp(section, slug)
      entry = read_data(section.to_s, slug.to_s.strip.downcase)
      return nil unless entry.is_a?(Hash)
      return nil if entry["price"].nil?
      entry["price"].to_f
    end

    def self.price_sp_to_cp(price_sp)
      (price_sp.to_f * 10).round
    end

    def self.item_catalog_price_sp(entry)
      return nil unless entry.is_a?(Hash)
      slug = entry["slug"].to_s.strip.downcase
      return nil if slug.empty?
      kind = entry["kind"].to_s
      section = case kind
                when "weapon" then "weapons"
                when "armor", "shield" then "armor"
                else "items"
                end
      price = catalog_price_sp(section, slug)
      return price unless price.nil?
      # shields live under items sometimes
      catalog_price_sp("items", slug) || catalog_price_sp("weapons", slug) || catalog_price_sp("armor", slug)
    end

    def self.vendor_stock_line(line)
      section = (line["section"] || line[:section]).to_s
      slug = (line["slug"] || line[:slug]).to_s.strip.downcase
      entry = read_data(section, slug)
      return nil unless entry.is_a?(Hash)

      price_sp = entry["price"]
      {
        section: section,
        slug: slug,
        name: entry["name"] || slug,
        kind: entry["kind"] || section,
        bulk: entry["bulk"],
        price_sp: price_sp.nil? ? nil : price_sp.to_f,
        price_cp: price_sp.nil? ? nil : price_sp_to_cp(price_sp),
        for_sale: !price_sp.nil?,
        entry: entry
      }
    end

    def self.vendor_catalog(vendor_slug)
      vendor = vendor_entry(vendor_slug)
      return [] unless vendor
      Array(vendor["stock"]).map { |line| vendor_stock_line(line) }.compact
    end

    def self.format_vendor_list
      lines = ["%xhMundane vendors%xn"]
      vendor_list.each do |slug|
        v = vendor_entry(slug)
        next unless v
        lines << "  %xh#{slug}%xn — #{v['name']}: #{v['description']}"
      end
      lines.join("%r")
    end

    def self.format_vendor_stock(vendor_slug)
      vendor = vendor_entry(vendor_slug)
      return t('pf2e.vendor_unknown') unless vendor

      lines = []
      lines << "%xh#{vendor['name']}%xn — #{vendor['description']}"
      lines << "%x(Prices in sp. Pay from purse. Sell-back is half price for mundane catalog gear.)%xn"
      stock = vendor_catalog(vendor_slug)
      if stock.empty?
        lines << "  (no stock listed)"
      else
        stock.each do |row|
          if row[:for_sale]
            price = row[:price_sp]
            price_s = price == price.to_i ? price.to_i.to_s : price.to_s
            lines << "  %xh#{row[:slug]}%xn  #{row[:name]}  #{price_s} sp  (Bulk #{row[:bulk]})"
          else
            lines << "  %xh#{row[:slug]}%xn  #{row[:name]}  %x(not for sale)%xn"
          end
        end
      end
      lines.join("%r")
    end

    def self.vendor_buy(char_or_sheet, vendor_slug, item_slug, qty: 1)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      qty = [qty.to_i, 1].max
      vendor = vendor_entry(vendor_slug)
      return { ok: false, error: "pf2e.vendor_unknown" } unless vendor

      key = item_slug.to_s.strip.downcase
      line = Array(vendor["stock"]).find { |s| (s["slug"] || s[:slug]).to_s.downcase == key }
      return { ok: false, error: "pf2e.vendor_not_stocked" } unless line

      info = vendor_stock_line(line)
      return { ok: false, error: "pf2e.vendor_not_stocked" } unless info
      return { ok: false, error: "pf2e.vendor_not_for_sale" } unless info[:for_sale]

      unit_cp = info[:price_cp]
      total_cp = unit_cp * qty

      spend = spend_cp(sheet, total_cp)
      return spend unless spend[:ok]

      kind = case info[:section]
             when "weapons" then "weapon"
             when "armor" then (info[:entry]["kind"] == "shield" ? "shield" : "armor")
             else info[:entry]["kind"] || "gear"
             end

      add = inventory_add(sheet,
                          slug: key,
                          kind: kind,
                          qty: qty,
                          name: info[:name],
                          bulk: info[:bulk],
                          society: false)
      unless add[:ok]
        adjust_money(sheet, cp_to_purse(total_cp))
        return add
      end

      {
        ok: true,
        error: nil,
        item: add[:item],
        money: sheet_money(sheet),
        spent_cp: total_cp,
        price_sp: info[:price_sp] * qty
      }
    end

    # Sell an inventory instance (or qty from a stack) back to a vendor.
    # Mundane catalog only; Society / unique / runed / magic blocked.
    def self.vendor_sell(char_or_sheet, item_id, qty: 1)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      qty = [qty.to_i, 1].max
      item = find_item(sheet, item_id)
      return { ok: false, error: "pf2e.item_not_found" } unless item

      if item["society"]
        return { ok: false, error: "pf2e.vendor_sell_society" }
      end
      if item["unique"] || item_is_unique?(item)
        return { ok: false, error: "pf2e.vendor_sell_unique" }
      end
      if item["contained_in"].to_s.strip != ""
        return { ok: false, error: "pf2e.vendor_sell_stowed" }
      end
      if item["equipped"]
        return { ok: false, error: "pf2e.vendor_sell_equipped" }
      end

      price_sp = item_catalog_price_sp(item)
      return { ok: false, error: "pf2e.vendor_sell_no_price" } if price_sp.nil?

      unit_cp = (price_sp_to_cp(price_sp) * SELL_RATE).floor
      return { ok: false, error: "pf2e.vendor_sell_no_price" } if unit_cp <= 0

      have_qty = item["qty"].to_i
      qty = [qty, have_qty].min

      remove = inventory_remove(sheet, item["id"], qty: qty)
      return remove unless remove[:ok]

      credit_cp = unit_cp * qty
      have = purse_to_cp(sheet_money(sheet))
      set_money(sheet, cp_to_purse(have + credit_cp))

      {
        ok: true,
        error: nil,
        item: remove[:item],
        money: sheet_money(sheet),
        credited_cp: credit_cp,
        qty: qty
      }
    end

  end
end

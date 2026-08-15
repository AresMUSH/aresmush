module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Vendor level lock
    #
    # Catalog item level must be <= character level + offset.
    # Higher-level gear is not for sale at coded vendors; it goes
    # through a staff job and staff issue (pf2e/set item/...).
    #
    # Config (game/config/pf2e.yml):
    #   vendor_level_lock: true
    #   vendor_level_offset: 0
    #
    # Catalog: set level: N on the entry. Missing level => 0 (mundane).
    # Spell items without level derive from spell.rank as 2*rank-1.
    # -------------------------------------------------

    class << self
      unless method_defined?(:vendor_buy_without_level_lock)
        alias_method :vendor_buy_without_level_lock, :vendor_buy
      end
      unless method_defined?(:vendor_stock_line_without_level)
        alias_method :vendor_stock_line_without_level, :vendor_stock_line
      end
      unless method_defined?(:format_vendor_stock_without_level)
        alias_method :format_vendor_stock_without_level, :format_vendor_stock
      end
    end

    def self.vendor_level_lock_enabled?
      val = Global.read_config("pf2e", "vendor_level_lock")
      return true if val.nil? # default on
      !!val
    end

    def self.vendor_level_offset
      Global.read_config("pf2e", "vendor_level_offset").to_i
    end

    # Effective item level from a catalog hash (weapons/armor/items entry).
    def self.catalog_item_level(entry)
      return 0 unless entry.is_a?(Hash)
      if !entry["level"].nil? && entry["level"].to_s != ""
        return [entry["level"].to_i, 0].max
      end

      sp = entry["spell"] || entry["spell_item"]
      if sp.is_a?(Hash) && !sp["rank"].nil?
        r = [sp["rank"].to_i, 1].max
        return [2 * r - 1, 1].max
      end

      0
    end

    def self.vendor_max_item_level(char_or_sheet)
      sheet = sheet_for(char_or_sheet)
      return 0 unless sheet
      [sheet.level.to_i, 1].max + vendor_level_offset
    end

    def self.vendor_item_level_allowed?(char_or_sheet, entry)
      return true unless vendor_level_lock_enabled?
      catalog_item_level(entry) <= vendor_max_item_level(char_or_sheet)
    end

    def self.vendor_stock_line(line)
      row = vendor_stock_line_without_level(line)
      return nil unless row
      row[:level] = catalog_item_level(row[:entry])
      row
    end

    def self.format_vendor_stock(vendor_slug, char_or_sheet = nil)
      vendor = vendor_entry(vendor_slug)
      return t('pf2e.vendor_unknown') unless vendor

      sheet = sheet_for(char_or_sheet)
      max_lvl = sheet ? vendor_max_item_level(sheet) : nil

      lines = []
      lines << "%xh#{vendor['name']}%xn - #{vendor['description']}"
      if vendor_level_lock_enabled? && max_lvl
        lines << "%x(Prices in sp from purse. You may buy items of level #{max_lvl} or lower. Higher = staff job + staff issue.)%xn"
      else
        lines << "%x(Prices in sp. Pay from purse. Sell-back is half price for mundane catalog gear.)%xn"
      end

      stock = vendor_catalog(vendor_slug)
      if stock.empty?
        lines << "  (no stock listed)"
      else
        stock.each do |row|
          lvl = row[:level].to_i
          lvl_bit = lvl > 0 ? " L#{lvl}" : ""
          if row[:for_sale]
            price = row[:price_sp]
            price_s = price == price.to_i ? price.to_i.to_s : price.to_s
            if max_lvl && vendor_level_lock_enabled? && lvl > max_lvl
              lines << "  %xh#{row[:slug]}%xn  #{row[:name]}#{lvl_bit}  #{price_s} sp  %x(staff only - above your level)%xn"
            else
              lines << "  %xh#{row[:slug]}%xn  #{row[:name]}#{lvl_bit}  #{price_s} sp  (Bulk #{row[:bulk]})"
            end
          else
            lines << "  %xh#{row[:slug]}%xn  #{row[:name]}#{lvl_bit}  %x(not for sale)%xn"
          end
        end
      end
      lines.join("%r")
    end

    def self.vendor_buy(char_or_sheet, vendor_slug, item_slug, qty: 1)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      if vendor_level_lock_enabled?
        vendor = vendor_entry(vendor_slug)
        return { ok: false, error: "pf2e.vendor_unknown" } unless vendor

        key = item_slug.to_s.strip.downcase
        line = Array(vendor["stock"]).find { |s| (s["slug"] || s[:slug]).to_s.downcase == key }
        return { ok: false, error: "pf2e.vendor_not_stocked" } unless line

        info = vendor_stock_line(line)
        return { ok: false, error: "pf2e.vendor_not_stocked" } unless info

        item_lvl = info[:level].to_i
        max_lvl = vendor_max_item_level(sheet)
        unless item_lvl <= max_lvl
          return {
            ok: false,
            error: "pf2e.vendor_level_too_high",
            item_level: item_lvl,
            char_level: sheet.level.to_i,
            max_level: max_lvl,
            slug: key
          }
        end
      end

      vendor_buy_without_level_lock(char_or_sheet, vendor_slug, item_slug, qty: qty)
    end

  end
end

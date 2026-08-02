module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Encumbrance (PF2e)
    # Gated by pf2e.yml use_encumbrance (true for Tapestry).
    #
    # Rules used:
    #   - Bulk "L" / light = 0.1; 10 L = 1 Bulk
    #   - Negligible / 0 = 0
    #   - 1000 coins on person = 1 Bulk (society_account excluded)
    #   - Worn armor: Bulk reduced by 1 (min 1, except light/unarmored may reach 0)
    #   - Items inside a container do not count separately; the container
    #     contributes bag bulk + contents after ignore_bulk
    #   - Comfortable limit = 5 + Str mod
    #   - Maximum = 10 + Str mod
    # -------------------------------------------------

    def self.use_encumbrance?
      val = Global.read_config("pf2e", "use_encumbrance")
      val == true || val.to_s == "true" || val.to_s == "1"
    end

    def self.parse_bulk(value)
      return 0.0 if value.nil?
      s = value.to_s.strip.downcase
      return 0.0 if s.empty? || s == "0" || s == "—" || s == "-" || s == "negligible"
      return 0.1 if s == "l" || s == "light"
      Float(s)
    rescue
      0.0
    end

    def self.format_bulk(num)
      n = num.to_f
      return "0" if n <= 0
      if (n - n.round).abs < 0.001
        n.round.to_s
      else
        sprintf("%.1f", n).sub(/\.?0+$/, "")
      end
    end

    def self.item_effective_bulk(entry)
      unit = parse_bulk(item_unit_bulk(entry))
      qty = [entry["qty"].to_i, 1].max
      total = unit * qty

      if entry["equipped"] && entry["kind"].to_s == "armor"
        cat = catalog_entry("armor", entry["slug"])
        category = cat.is_a?(Hash) ? cat["category"].to_s : ""
        reduced = total - 1.0
        if %w[light unarmored].include?(category)
          total = [reduced, 0.0].max
        else
          total = [reduced, 1.0].max
        end
      end
      total
    end

    # Top-level carried bulk only (skip items already inside a bag).
    def self.inventory_bulk(char_or_sheet)
      list = sheet_inventory(char_or_sheet)
      list.sum do |e|
        next 0.0 if e["contained_in"].to_s.strip != ""
        if container?(e)
          container_carried_bulk(char_or_sheet, e)
        else
          item_effective_bulk(e)
        end
      end
    end

    def self.coin_bulk(char_or_sheet)
      coin_count(char_or_sheet) / 1000.0
    end

    def self.total_bulk(char_or_sheet)
      inventory_bulk(char_or_sheet) + coin_bulk(char_or_sheet)
    end

    def self.bulk_limit(char_or_sheet)
      5 + ability_mod(char_or_sheet, "str")
    end

    def self.bulk_maximum(char_or_sheet)
      10 + ability_mod(char_or_sheet, "str")
    end

    def self.encumbrance_status(char_or_sheet)
      return :ok unless use_encumbrance?
      bulk = total_bulk(char_or_sheet)
      return :over_max if bulk > bulk_maximum(char_or_sheet)
      return :encumbered if bulk > bulk_limit(char_or_sheet)
      :ok
    end

    def self.encumbrance_summary(char_or_sheet)
      enabled = use_encumbrance?
      bulk = total_bulk(char_or_sheet)
      {
        enabled: enabled,
        bulk: bulk,
        bulk_display: format_bulk(bulk),
        inventory_bulk: inventory_bulk(char_or_sheet),
        coin_bulk: coin_bulk(char_or_sheet),
        limit: bulk_limit(char_or_sheet),
        maximum: bulk_maximum(char_or_sheet),
        status: enabled ? encumbrance_status(char_or_sheet) : :disabled,
        coins: coin_count(char_or_sheet),
        money: format_money(sheet_money(char_or_sheet)),
        society: format_money(sheet_society_account(char_or_sheet))
      }
    end

  end
end

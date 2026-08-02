module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Containers / bags
    #
    # Catalog items may define:
    #   container:
    #     capacity: 4        # max Bulk held
    #     ignore_bulk: 2     # first N Bulk of contents ignored for carrier
    #     worn_bulk: 0       # bulk of bag when worn
    #
    # Inventory instances:
    #   contained_in: "i3"   # id of container instance (nil = carried)
    #
    # Policy: Society-flagged items cannot be stowed (anti-hoarding).
    # -------------------------------------------------

    def self.container_rules_for(entry)
      cat = catalog_entry(entry["kind"], entry["slug"])
      return nil unless cat.is_a?(Hash)
      rules = cat["container"]
      return nil unless rules.is_a?(Hash)
      {
        capacity: parse_bulk(rules["capacity"]),
        ignore_bulk: parse_bulk(rules["ignore_bulk"] || 0),
        worn_bulk: parse_bulk(rules["worn_bulk"].nil? ? entry["bulk"] : rules["worn_bulk"])
      }
    end

    def self.container?(entry)
      !container_rules_for(entry).nil?
    end

    def self.items_in_container(char_or_sheet, container_id)
      id = container_id.to_s.downcase
      sheet_inventory(char_or_sheet).select { |e| e["contained_in"].to_s.downcase == id }
    end

    def self.container_contents_bulk(char_or_sheet, container_id)
      items_in_container(char_or_sheet, container_id).sum { |e| item_effective_bulk(e) }
    end

    def self.container_can_accept?(char_or_sheet, container_entry, add_bulk)
      rules = container_rules_for(container_entry)
      return false unless rules
      current = container_contents_bulk(char_or_sheet, container_entry["id"])
      current + add_bulk.to_f <= rules[:capacity] + 0.0001
    end

    def self.container_carried_bulk(char_or_sheet, container_entry)
      rules = container_rules_for(container_entry)
      return item_effective_bulk(container_entry) unless rules

      contents = container_contents_bulk(char_or_sheet, container_entry["id"])
      counted_contents = [contents - rules[:ignore_bulk], 0.0].max
      bag_bulk = if container_entry["equipped"]
                   rules[:worn_bulk]
                 else
                   parse_bulk(item_unit_bulk(container_entry))
                 end
      bag_bulk + counted_contents
    end

    # gear/stow <item_id> <bag_id>
    def self.inventory_stow(char_or_sheet, item_id, container_id)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      list = sheet_inventory(sheet)
      item = list.find { |e| e["id"].to_s.downcase == item_id.to_s.downcase }
      bag  = list.find { |e| e["id"].to_s.downcase == container_id.to_s.downcase }
      return { ok: false, error: "pf2e.item_not_found" } unless item
      return { ok: false, error: "pf2e.item_not_found" } unless bag

      if item["id"].to_s.downcase == bag["id"].to_s.downcase
        return { ok: false, error: "pf2e.stow_self" }
      end

      unless container?(bag)
        return { ok: false, error: "pf2e.stow_not_container" }
      end

      # Society gear stays on the person — no packing it away.
      if item["society"]
        return { ok: false, error: "pf2e.stow_society_blocked" }
      end

      # Do not nest containers (keeps capacity simple and readable).
      if container?(item)
        return { ok: false, error: "pf2e.stow_no_nested" }
      end

      if item["contained_in"].to_s.strip != ""
        return { ok: false, error: "pf2e.stow_already" }
      end

      # Equipped items must come off first.
      if item["equipped"]
        return { ok: false, error: "pf2e.stow_equipped" }
      end

      add_bulk = item_effective_bulk(item)
      unless container_can_accept?(sheet, bag, add_bulk)
        return { ok: false, error: "pf2e.stow_full" }
      end

      item["contained_in"] = bag["id"]
      save_inventory(sheet, list)
      {
        ok: true,
        error: nil,
        item: item,
        container: bag,
        inventory: sheet_inventory(sheet)
      }
    end

    # gear/retrieve <item_id>
    def self.inventory_retrieve(char_or_sheet, item_id)
      sheet = sheet_for(char_or_sheet)
      return { ok: false, error: "pf2e.no_sheet" } unless sheet

      list = sheet_inventory(sheet)
      item = list.find { |e| e["id"].to_s.downcase == item_id.to_s.downcase }
      return { ok: false, error: "pf2e.item_not_found" } unless item

      if item["contained_in"].to_s.strip.empty?
        return { ok: false, error: "pf2e.retrieve_not_stowed" }
      end

      bag_id = item["contained_in"]
      item["contained_in"] = nil
      save_inventory(sheet, list)
      {
        ok: true,
        error: nil,
        item: item,
        container_id: bag_id,
        inventory: sheet_inventory(sheet)
      }
    end

  end
end

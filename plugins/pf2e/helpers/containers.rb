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
    # Inventory instances can set:
    #   contained_in: "i3"   # id of container instance
    #
    # Encumbrance uses ignore_bulk when container is equipped/worn.
    # Full nested container UI (stow/retrieve commands) can layer on later;
    # capacity checks are ready for that path.
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

    # Bulk contributed by a container + its contents toward the character load.
    # PF2e backpack: first ignore_bulk of contents do not count.
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

  end
end

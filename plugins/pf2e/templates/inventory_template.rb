module AresMUSH
  module Pf2e
    class InventoryTemplate < ErbTemplateRenderer

      attr_accessor :char, :sheet, :filter_kind

      def initialize(char, sheet, filter_kind: nil)
        @char = char
        @sheet = sheet
        @filter_kind = filter_kind
        super File.dirname(__FILE__) + "/inventory.erb"
      end

      def name
        char.name
      end

      def purse_display
        Pf2e.format_money(Pf2e.sheet_money(sheet))
      end

      def society_display
        Pf2e.format_money(Pf2e.sheet_society_account(sheet))
      end

      def encumbrance_enabled
        Pf2e.use_encumbrance?
      end

      def bulk_display
        Pf2e.format_bulk(Pf2e.total_bulk(sheet))
      end

      def bulk_limit
        Pf2e.bulk_limit(sheet)
      end

      def bulk_maximum
        Pf2e.bulk_maximum(sheet)
      end

      def load_label
        case Pf2e.encumbrance_status(sheet)
        when :ok then "%xgUnencumbered%xn"
        when :encumbered then "%xyEncumbered%xn"
        when :over_max then "%xrOver maximum%xn"
        else "—"
        end
      end

      def items
        list = Pf2e.sheet_inventory(sheet)
        if filter_kind
          list = list.select { |e| e["kind"].to_s == filter_kind.to_s }
        end
        list
      end

      def equipped_block
        rows = items.select { |e| e["equipped"] }
        return "  (none)" if rows.empty?
        rows.map { |e| "  #{Pf2e.format_item_line(e)}" }.join("%r")
      end

      def carried_block
        rows = items.reject { |e| e["equipped"] || e["contained_in"].to_s.strip != "" }
        return "  (none)" if rows.empty?
        rows.map { |e| "  #{Pf2e.format_item_line(e)}" }.join("%r")
      end

      def stowed_block
        rows = items.select { |e| e["contained_in"].to_s.strip != "" }
        return "  (none)" if rows.empty?
        rows.map { |e| "  #{Pf2e.format_item_line(e)}" }.join("%r")
      end
    end
  end
end

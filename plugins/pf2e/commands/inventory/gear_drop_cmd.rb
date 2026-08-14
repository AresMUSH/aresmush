module AresMUSH
  module Pf2e
    class GearDropCmd
      include CommandHandler

      attr_accessor :item_id, :qty

      def parse_args
        # gear/drop <id> [qty]
        parts = cmd.args.to_s.strip.split(/\s+/)
        self.item_id = parts[0] ? parts[0].strip.downcase : nil
        self.qty = parts[1] ? parts[1].to_i : nil
      end

      def required_args
        [ self.item_id ]
      end

      def handle
        result = Pf2e.inventory_remove(enactor, self.item_id, qty: self.qty)
        unless result[:ok]
          client.emit_failure t(result[:error])
          return
        end

        item = result[:item]
        client.emit_success t('pf2e.gear_drop_ok',
                             :name => Pf2e.item_display_name(item),
                             :id => item["id"],
                             :qty => item["qty"])
      end
    end
  end
end

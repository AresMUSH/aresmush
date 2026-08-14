module AresMUSH
  module Pf2e
    class GearAddCmd
      include CommandHandler

      attr_accessor :slug, :qty

      def parse_args
        # gear/add <slug> [qty]
        parts = cmd.args.to_s.strip.split(/\s+/)
        self.slug = parts[0] ? parts[0].strip.downcase : nil
        self.qty = parts[1] ? parts[1].to_i : 1
        self.qty = 1 if self.qty < 1
      end

      def required_args
        [ self.slug ]
      end

      def handle
        result = Pf2e.inventory_add_from_catalog(enactor, self.slug, qty: self.qty)
        unless result[:ok]
          client.emit_failure t(result[:error])
          return
        end

        item = result[:item]
        client.emit_success t('pf2e.gear_add_ok',
                             :name => Pf2e.item_display_name(item),
                             :id => item["id"],
                             :qty => item["qty"])
      end
    end
  end
end

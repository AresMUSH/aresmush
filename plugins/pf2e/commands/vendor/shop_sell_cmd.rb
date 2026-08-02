module AresMUSH
  module Pf2e
    class ShopSellCmd
      include CommandHandler

      attr_accessor :item_id, :qty

      def parse_args
        # shop/sell <item_id> [qty]
        parts = cmd.args.to_s.strip.split(/\s+/)
        self.item_id = parts[0] ? parts[0].downcase : nil
        self.qty = parts[1] ? parts[1].to_i : 1
        self.qty = 1 if self.qty < 1
      end

      def required_args
        [ self.item_id ]
      end

      def handle
        result = Pf2e.vendor_sell(enactor, self.item_id, qty: self.qty)
        unless result[:ok]
          client.emit_failure t(result[:error])
          return
        end

        item = result[:item]
        client.emit_success t('pf2e.vendor_sell_ok',
                             :name => Pf2e.item_display_name(item),
                             :id => item["id"],
                             :qty => result[:qty],
                             :credited => Pf2e.format_money(Pf2e.cp_to_purse(result[:credited_cp])),
                             :purse => Pf2e.format_money(result[:money]))
      end
    end
  end
end

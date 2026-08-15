module AresMUSH
  module Pf2e
    class ShopBuyCmd
      include CommandHandler

      attr_accessor :vendor_slug, :item_slug, :qty

      def parse_args
        # shop/buy <vendor> <slug> [qty]
        parts = cmd.args.to_s.strip.split(/\s+/)
        self.vendor_slug = parts[0] ? parts[0].downcase : nil
        self.item_slug = parts[1] ? parts[1].downcase : nil
        self.qty = parts[2] ? parts[2].to_i : 1
        self.qty = 1 if self.qty < 1
      end

      def required_args
        [ self.vendor_slug, self.item_slug ]
      end

      def handle
        result = Pf2e.vendor_buy(enactor, self.vendor_slug, self.item_slug, qty: self.qty)
        unless result[:ok]
          if result[:error] == "pf2e.vendor_level_too_high"
            client.emit_failure t('pf2e.vendor_level_too_high',
                                 :slug => result[:slug] || self.item_slug,
                                 :item_level => result[:item_level],
                                 :char_level => result[:char_level],
                                 :max_level => result[:max_level])
          else
            client.emit_failure t(result[:error])
          end
          return
        end

        item = result[:item]
        client.emit_success t('pf2e.vendor_buy_ok',
                             :name => Pf2e.item_display_name(item),
                             :id => item["id"],
                             :qty => self.qty,
                             :spent => Pf2e.format_money(Pf2e.cp_to_purse(result[:spent_cp])),
                             :purse => Pf2e.format_money(result[:money]))
      end
    end
  end
end

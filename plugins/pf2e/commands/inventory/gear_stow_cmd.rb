module AresMUSH
  module Pf2e
    class GearStowCmd
      include CommandHandler

      attr_accessor :item_id, :bag_id

      def parse_args
        # gear/stow <item_id> <bag_id>
        parts = cmd.args.to_s.strip.split(/\s+/)
        self.item_id = parts[0] ? parts[0].strip.downcase : nil
        self.bag_id = parts[1] ? parts[1].strip.downcase : nil
      end

      def required_args
        [ self.item_id, self.bag_id ]
      end

      def handle
        result = Pf2e.inventory_stow(enactor, self.item_id, self.bag_id)
        unless result[:ok]
          client.emit_failure t(result[:error])
          return
        end

        item = result[:item]
        bag = result[:container]
        client.emit_success t('pf2e.stow_ok',
                             :item => Pf2e.item_display_name(item),
                             :item_id => item["id"],
                             :bag => Pf2e.item_display_name(bag),
                             :bag_id => bag["id"])
      end
    end
  end
end

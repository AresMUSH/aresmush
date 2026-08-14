module AresMUSH
  module Pf2e
    class GearUnequipCmd
      include CommandHandler

      attr_accessor :item_id

      def parse_args
        self.item_id = cmd.args ? cmd.args.strip.downcase : nil
      end

      def required_args
        [ self.item_id ]
      end

      def handle
        result = Pf2e.inventory_equip(enactor, self.item_id, equipped: false)
        unless result[:ok]
          client.emit_failure t(result[:error])
          return
        end

        item = result[:item]
        client.emit_success t('pf2e.gear_unequip_ok',
                             :name => Pf2e.item_display_name(item),
                             :id => item["id"])
      end
    end
  end
end

module AresMUSH
  module Pf2e
    class GearRetrieveCmd
      include CommandHandler

      attr_accessor :item_id

      def parse_args
        # gear/retrieve <item_id>
        self.item_id = cmd.args ? cmd.args.strip.downcase : nil
      end

      def required_args
        [ self.item_id ]
      end

      def handle
        result = Pf2e.inventory_retrieve(enactor, self.item_id)
        unless result[:ok]
          client.emit_failure t(result[:error])
          return
        end

        item = result[:item]
        client.emit_success t('pf2e.retrieve_ok',
                             :item => Pf2e.item_display_name(item),
                             :item_id => item["id"],
                             :bag_id => result[:container_id])
      end
    end
  end
end

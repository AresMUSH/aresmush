module AresMUSH
  module Simpleinventory
    class ItemUnequipCmd
    #item/equip <item>
      include CommandHandler
      attr_accessor  :item_name

      def parse_args
        self.item_name = titlecase_arg(cmd.args)
      end

      def check_errors
        return t('simple_inventory.item_not_equipped') if item_name != enactor.item_equipped
      end

      def handle
        enactor.update(item_equipped: "None")
        client.emit_success t('simple_inventory.item_unequipped', :item => self.item_name)
        enactor_room.emit t('simple_inventory.has_unequipped_item', :name => self.enactor.name, :item => self.item_name)
      end


    end
  end
end

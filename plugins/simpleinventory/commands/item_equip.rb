module AresMUSH
  module Simpleinventory
    class ItemEquipCmd
    #item/equip <item>
      include CommandHandler
      attr_accessor :item_name

      def parse_args
        self.item_name = titlecase_arg(cmd.args)
      end

      def check_errors
        return t('simple_inventory.dont_have_item') if !enactor.items ||
          !enactor.items.include?(self.item_name)
      end

      def handle
        enactor.update(item_equipped: self.item_name)
        client.emit_success t('simple_inventory.item_equipped', :item => enactor.item_equipped)
        message = t('simple_inventory.equipped_item', :name => enactor.name, :item => enactor.item_equipped)
        enactor.room.emit_success message
        if enactor.room.scene
          Scenes.add_to_scene(enactor.room.scene, message)
        end
        Achievements.award_achievement(enactor, "equipped_item")
      end

    end
  end
end

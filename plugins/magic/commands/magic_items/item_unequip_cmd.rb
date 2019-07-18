module AresMUSH
  module Magic
    class ItemUnequipCmd
    #item/equip <item>
      include CommandHandler
      attr_accessor :caster, :caster_name, :item_name

      def parse_args
        self.item_name = titlecase_arg(cmd.args)
      end

      def check_errors
        return t('magic.item_not_equipped') if item_name != caster.magic_item_equipped
      end

      def handle
        caster.update(magic_item_equipped: "None")
        client.emit_success t('magic.item_unequipped', :item => self.item_name)
        enactor_room.emit t('magic.has_unequipped_item', :name => self.caster.name, :item => self.item_name)
      end


    end
  end
end

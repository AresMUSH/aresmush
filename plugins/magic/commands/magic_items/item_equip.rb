module AresMUSH
  module Magic
    class ItemEquipCmd
    #item/equip <item>
      include CommandHandler
      attr_accessor :item_name

      def parse_args
        self.item_name = titlecase_arg(cmd.args)
      end

      def check_errors
        return t('magic.dont_have_item') if !enactor.magic_items.include?(self.item_name)
      end

      def handle
        enactor.update(magic_item_equipped: self.item_name)
        client.emit_success t('magic.item_equipped', :item => enactor.magic_item_equipped)
        message = "Equipped a magic item."
        Achievements.award_achievement(enactor, "equipped_magic_item", 'magic', message)
      end

    end
  end
end

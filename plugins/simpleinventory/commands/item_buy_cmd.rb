module AresMUSH
  module Simpleinventory
    class BuyItemCmd
      include CommandHandler
# item/buy <item> - Buy an item. If item isn't in config, request it.
      attr_accessor :char, :item,  :item_name

      def parse_args
        self.item_name = titlecase_arg(cmd.args)
      end

      def check_errors
        return t('simple_inventory.not_item') if !Simpleinventory.is_item?(self.item_name)
        return t('simple_inventory.item_not_available') if !Global.read_config("items", self.item_name, "available") && !Simpleinventory.is_potion?(self.item_name)
        luck = Global.read_config("items", self.item_name, "cost")
        return t('fs3skills.not_enough_points') if enactor.luck < luck
        return nil
      end

      def handle
        items = enactor.items || []
        items.concat [self.item_name]
        enactor.update(items: items)
        luck = Global.read_config("items", self.item_name, "cost")


        enactor.spend_luck(luck)
        Achievements.award_achievement(enactor, "fs3_luck_spent")

        job_message = t('simple_inventory.bought_item_job', :name => enactor.name, :item => item_name, :luck => luck)
        category = Global.read_config("simple_inventory", "item_category")
        status = Jobs.create_job(category, t('fs3skills.luck_point_spent', :name => enactor.name, :reason => "buying #{self.item_name}."), job_message, enactor)
        if (status[:job])
          Jobs.close_job(Game.master.system_character, status[:job])
        end
        Global.logger.info "#{enactor.name} bought #{self.item_name}."
        client.emit_success job_message

      end

    end
  end
end

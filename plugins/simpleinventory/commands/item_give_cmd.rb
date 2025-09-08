module AresMUSH
  module Simpleinventory
    class GiveItemCmd
      include CommandHandler
# item/give <name>=<item> - Give a potion to someone.
      attr_accessor :char, :item, :target, :item_name, :other_client

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        target_name = titlecase_arg(args.arg1)
        self.item_name = titlecase_arg(args.arg2)
        self.target = Character.find_one_by_name(target_name)
      end

      def check_errors
        return t('simple_inventory.dont_have_item') if !enactor.items ||
          !enactor.items.include?(self.item_name)
        return t('simple_inventory.not_character') if !self.target
        return t('simple_inventory.unequip_first', :item => item_name) if (item_name == enactor.item_equipped && enactor.items.count(item_name) < 2)
        return nil
      end

      def handle
        self.other_client = Login.find_client(target)

        target_items = self.target.items || []
        target_items.concat [self.item_name]
        self.target.update(items: target_items)

        enactor_items = enactor.items
        enactor_items.delete_at(enactor_items.index(self.item_name))
        enactor.update(items: enactor_items)


        client.emit_success t('simple_inventory.give_item', :target => target.name, :item => item_name)

        message = t('simple_inventory.given_item', :name => enactor.name, :item => item_name)
        Login.emit_if_logged_in self.target, message
        Login.notify(self.target, :item, message, nil)
      end

    end
  end
end

module AresMUSH
  module Simpleinventory
    class ItemAddCmd
      include CommandHandler
      # item/add <name>=<item> - Give someone an item.

      attr_accessor :target, :item_name

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target = Character.find_one_by_name(args.arg1)
        self.item_name = titlecase_arg(args.arg2)
      end

      def check_can_set
        return t('dispatcher.not_allowed') if !enactor.has_permission?("manage_items")
      end

      def check_errors
        return t('magic.invalid_name') if !self.target
        return t('simple_inventory.not_item') if !Simpleinventory.is_item?(self.item_name)
        return nil
      end

      def handle

        target_items = self.target.items || []
        target_items.concat [self.item_name]
        self.target.update(items: target_items)

        client.emit_success t('simple_inventory.added_item', :item => self.item_name, :target => target.name)

        message = t('simple_inventory.given_item', :name => enactor.name, :item => self.item_name)
        Login.emit_if_logged_in self.target, message
        Login.notify(self.target, :item, message, nil)
      end






    end
  end
end

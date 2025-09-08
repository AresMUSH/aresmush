module AresMUSH
  module Simpleinventory
    class ItemRemoveCmd
      include CommandHandler
      # item/remove <name>=<item> - Remove an item from someone.

      attr_accessor :target, :item_name, :item

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target = Character.find_one_by_name(args.arg1)
        self.item_name = titlecase_arg(args.arg2)
        Global.logger.debug "Item name #{self.item_name}"
      end


      def check_can_set
        return t('dispatcher.not_allowed') if !enactor.has_permission?("manage_magic")
      end

      def check_errors
        return t('simple_inventory.invalid_name') if !self.target
        return t('simple_inventory.not_item') if !item_name
        return t('simple_inventory.target_does_not_have_item') if !self.target_items ||
          !self.target.items.include?(self.item_name)
        return nil
      end

      def handle
        target_items = self.target.items
        target_items.delete_at(target_items.index(self.item_name))
        self.target.update(items: target_items)

        client.emit_success t('simple_inventory.removed_item', :item => item_name, :target => target.name)

        message = t('simple_inventory.item_removed', :name => enactor.name, :item => item_name)
        client.emit_success message
        Login.notify(self.target, :item, message, nil)
      end






    end
  end
end

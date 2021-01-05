module AresMUSH
  module Magic
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
        return t('dispatcher.not_allowed') if !FS3Skills.can_manage_abilities?(enactor)
      end

      def check_errors
        return t('magic.invalid_name') if !self.target
        return t('magic.not_item') if !item_name
        return t('magic.target_does_not_have_item') if !self.target.magic_items.include?(self.item_name)
        return nil
      end

      def handle
        target_magic_items = self.target.magic_items
        target_magic_items.delete_at(target_magic_items.index(self.item_name))
        self.target.update(magic_items: target_magic_items)

        client.emit_success t('magic.removed_item', :item => item_name, :target => target.name)

        message = t('magic.magic_item_removed', :name => enactor.name, :item => item_name)
        client.emit_success message
        Login.notify(self.target, :item, message, nil)
      end






    end
  end
end

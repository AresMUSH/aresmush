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
        self.item = Magic.find_item(target, item_name)
      end


      def check_can_set
        return t('dispatcher.not_allowed') if !FS3Skills.can_manage_abilities?(enactor)
      end

      def check_errors
        return t('magic.invalid_name') if !self.target
        return t('magic.not_item') if !item_name
        return t('magic.target_does_not_have_item') if !item
        return nil
      end

      def handle
        self.item = Magic.find_item(target, item_name)

        item.delete

        client.emit_success t('magic.removed_item', :item => item_name, :target => target.name)

        message = t('magic.magic_item_removed', :name => enactor.name, :item => item_name)
        client.emit_success message
        Mail.send_mail([target.name], t('magic.magic_item_removed_subj', :item => item_name), message, nil)

      end






    end
  end
end

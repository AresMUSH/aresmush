module AresMUSH
  module Custom
    class ItemRemoveCmd
      include CommandHandler
# item/remove <name>=<item> - Remove an item from someone.

      attr_accessor :target, :item_name, :item

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.target = Character.find_one_by_name(args.arg1)
        self.item_name = titlecase_arg(args.arg2)
        self.item = Custom.find_item(target, item_name)
      end

      def check_can_set
        return t('dispatcher.not_allowed') if !FS3Skills.can_manage_abilities?(enactor)
      end

      def check_errors
        return t('custom.invalid_name') if !self.target
        return t('custom.not_item') if !Custom.is_item?(self.item_name)
        return t('custom.target_does_not_have_item') if !item
        return nil
      end

      def handle


        item.delete

        client.emit_success t('custom.removed_item', :item => item_name, :target => target.name)

        message = t('custom.magic_item_removed', :name => enactor.name, :item_name => item_name)
        client.emit_success message
        Mail.send_mail([target.name], t('custom.magic_item_removed_subj'), message, nil)

      end






    end
  end
end

module AresMUSH
  module Magic
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
        return t('magic.dont_have_item') if !enactor.magic_items.include?(self.item_name)
        return t('magic.not_character') if !self.target
        return t('magic.unequip_first', :item => item.name) if item_name == enactor.magic_item_equipped
        return nil
      end

      def handle
        self.other_client = Login.find_client(target)

        target_magic_items = self.target.magic_items
        target_magic_items.concat [self.item_name]
        self.target.update(magic_items: target_magic_items)

        enactor_magic_items = enactor.magic_items
        enactor_magic_items.delete_at(enactor_magic_items.index(self.item_name))
        enactor.update(magic_items: enactor_magic_items)


        client.emit_success t('magic.give_item', :target => target.name, :item => item_name)

        message = t('magic.given_magic_item', :name => enactor.name, :item => item_name)
        Login.emit_if_logged_in self.target, message
        Mail.send_mail([target.name], t('magic.given_magic_item_subj', :item => item_name), message, nil)
      end

    end
  end
end

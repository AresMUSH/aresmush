module AresMUSH
  module Magic
    class GiveItemCmd
      include CommandHandler
# item/give <name>=<item> - Give a potion to someone.
      attr_accessor :char, :item, :target, :item_name, :other_client

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.char = titlecase_arg(args.arg1)
        self.item_name = titlecase_arg(args.arg2)
        self.item = Magic.find_item(enactor, item_name)
        self.target = Character.find_one_by_name(self.char)

      end

      def check_errors
        return t('magic.dont_have_item') if !item
        return t('magic.not_character') if !self.target
        return t('magic.unequip_first', :item => item.name) if item_name == enactor.magic_item_equipped
        return nil
      end

      def handle
        self.other_client = Login.find_client(target)

        MagicItems.create(name: item.name, character: self.target, desc: item.desc, weapon_specials: item.weapon_specials, armor_specials: item.armor_specials, spell: item.spell, item_spell_mod: item.item_spell_mod, item_attack_mod: item.item_attack_mod)

        self.item.delete

        client.emit_success t('magic.give_item', :target => target.name, :item => item.name)


        message = t('magic.given_magic_item', :name => enactor.name, :item => item_name)
        Login.emit_if_logged_in self.target, message
        Mail.send_mail([target.name], t('magic.given_magic_item_subj', :item => item_name), message, nil)
      end

    end
  end
end

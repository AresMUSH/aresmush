module AresMUSH
  module Magic
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
        return t('dispatcher.not_allowed') if !FS3Skills.can_manage_abilities?(enactor)
      end

      def check_errors
        return t('magic.invalid_name') if !self.target
        return t('magic.not_item') if !Magic.is_item?(self.item_name)
        return nil
      end

      def handle
        #Reading Config
        weapon_specials = Global.read_config("magic-items", self.item_name, "weapon_specials")
        armor_specials = Global.read_config("magic-items", self.item_name, "armor_specials")
        spell_mod = Global.read_config("magic-items", self.item_name, "spell_mod")
        attack_mod = Global.read_config("magic-items", self.item_name, "attack_mod")
        spell = Global.read_config("magic-items", self.item_name, "spell")
        desc = Global.read_config("magic-items", self.item_name, "desc")


        MagicItems.create(name: self.item_name, character: self.target, desc: desc, weapon_specials: weapon_specials, armor_specials: armor_specials, spell: spell, item_spell_mod: spell_mod, item_attack_mod: attack_mod)

        client.emit_success t('magic.added_item', :item => self.item_name, :target => target.name)

        message = t('magic.given_magic_item', :name => enactor.name, :item => self.item_name)
        Login.emit_if_logged_in self.target, message
        Mail.send_mail([target.name], t('magic.given_magic_item_subj', :item => self.item_name), message, nil)

      end






    end
  end
end

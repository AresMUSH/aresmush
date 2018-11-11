module AresMUSH
  module Custom
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
        return t('custom.invalid_name') if !self.target
        return t('custom.not_item') if !Custom.is_item?(self.item_name)
        return nil
      end

      def handle
        #Reading Config
        weapon_specials = Global.read_config("magic-items", self.item_name, "weapon_specials")
        armor_specials = Global.read_config("magic-items", self.item_name, "armor_specials")
        spell_mod = Global.read_config("magic-items", self.item_name, "spell_mod")
        spell = Global.read_config("magic-items", self.item_name, "spell")
        desc = Global.read_config("magic-items", self.item_name, "desc")


        MagicItems.create(name: self.item_name, character: self.target, desc: desc, weapon_specials: weapon_specials, armor_specials: armor_specials, spell: spell, item_spell_mod: spell_mod)

        client.emit_success t('custom.added_item', :item => name, :target => target.name)

        message = t('custom.given_magic_item', :name => enactor.name, :item => name)
        client.emit_success message
        Mail.send_mail([target.name], t('custom.given_magic_item_subj', :item => name), message, nil)

      end






    end
  end
end

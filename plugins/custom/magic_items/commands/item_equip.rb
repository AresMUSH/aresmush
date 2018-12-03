module AresMUSH
  module Custom
    class ItemEquipCmd
    #item/equip <item>
      include CommandHandler
      attr_accessor :caster, :caster_name, :item_name

      # Using 'caster' even though it should probably be user or something just for variable consistency with helpers.
      def parse_args
          if (cmd.args =~ /\//)
          #Forcing NPC or PC to equip item
          args = cmd.parse_args(/(?<arg1>[^\/]+)\/(?<arg2>[^\+]+)/)
          combat = enactor.combat
          caster_name = titlecase_arg(args.arg1)
          #Returns char or NPC
          self.caster = FS3Combat.find_named_thing(caster_name, enactor)
          self.item_name = titlecase_arg(args.arg2)

        else
           args = cmd.parse_args(/(?<arg1>[^\+]+)\+?(?<arg2>.+)?/)
           #Returns char or NPC
           self.caster = enactor
           self.item_name = titlecase_arg(args.arg1)

          end
      end

      def check_errors
        return t('custom.not_character') if !caster
        return t('item_not_owned') if !Custom.find_item(caster, item_name)
      end

      def handle
        item = Custom.find_item(enactor, item_name)
        caster.update(magic_item_equipped: item_name)
        client.emit_success t('custom.item_equipped', :item => caster.magic_item_equipped)
        message = "Equipped a magic item."
        Achievements.award_achievement(char, "equipped_magic_item", 'magic', message)
      end


    end
  end
end

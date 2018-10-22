module AresMUSH
  module Custom
    class ItemUnequipCmd
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
        return t('custom.item_not_equipped') if item_name != caster.magic_item_equipped
      end

      def handle
        item = Custom.find_item(caster, item_name)
        caster.update(magic_item_equipped: "None")
        client.emit_success t('custom.item_unequipped', :item => self.item_name)
        enactor_room.emit t('custom.has_unequipped_item', :name => self.caster.name, :item => self.item_name)
      end


    end
  end
end

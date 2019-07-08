module AresMUSH
  module Magic
    class CombatPotionCmd
    #combat/potion <potion>
      include CommandHandler
      attr_accessor :potion, :potion_name, :spell, :roll, :caster, :caster_combat, :caster_name, :args

      # Using 'caster' even though it should probably be user or something just for variable consistency with helpers.
      def parse_args
          if (cmd.args =~ /\//)
          #Forcing NPC or PC to use potion
          args = cmd.parse_args(/(?<arg1>[^\/]+)\/(?<arg2>[^\+]+)/)
          caster_name = titlecase_arg(args.arg1)
          self.caster = FS3Combat.find_named_thing(caster_name, enactor)
          self.potion_name = titlecase_arg(args.arg2)
        else
          #Enactor uses potion
          args = cmd.parse_args(/(?<arg1>[^\+]+)\+?(?<arg2>.+)?/)
          self.caster = enactor
          self.potion_name = titlecase_arg(args.arg1)
        end
        combat = enactor.combat
        self.potion = Magic.find_potion_has(caster, self.potion_name)
        arg_array = [self.caster.name, self.potion.name]
        self.args = arg_array.join("/")
      end

      def check_errors
        return t('magic.not_character') if !caster
        return t('magic.dont_have_potion') if (!caster.combatant.is_npc? && !self.potion)
        return t('magic.potion_ko') if self.caster_combat.is_ko
      end

      def handle
        FS3Combat.set_action(client, enactor, enactor.combat, caster.combatant, FS3Combat::PotionAction, self.potion.name)
        self.potion.delete
        Magic.handle_potions_used_achievement(caster)
      end







    end
  end
end

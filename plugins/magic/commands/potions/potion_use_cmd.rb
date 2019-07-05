module AresMUSH
  module Magic
    class PotionUseCmd
    #potion/use <potion>
      include CommandHandler
      attr_accessor :potion, :potion_name, :spell, :roll, :caster, :caster_combat, :caster_name, :args

      # Using 'caster' even though it should probably be user or something just for variable consistency with helpers.
      def parse_args
          if (cmd.args =~ /\//)
          #Forcing NPC or PC to use potion
          args = cmd.parse_args(/(?<arg1>[^\/]+)\/(?<arg2>[^\+]+)/)
          combat = enactor.combat
          caster_name = titlecase_arg(args.arg1)
          #Returns char or NPC
          self.caster = FS3Combat.find_named_thing(caster_name, enactor)
          #Returns combatant
          if enactor.combat
            self.caster_combat = combat.find_combatant(caster_name)
            self.spell = titlecase_arg(args.arg2)
            self.potion_name = titlecase_arg(args.arg2)
          end
        else
           args = cmd.parse_args(/(?<arg1>[^\+]+)\+?(?<arg2>.+)?/)
           #Returns char or NPC
           caster_name = enactor.name
           self.caster = enactor
           self.spell = titlecase_arg(args.arg1)
           self.potion_name = titlecase_arg(args.arg1)

           #Returns combatant
           if enactor.combat
             self.caster_combat = enactor.combatant
           end
          end

          arg_array = [caster_name, potion_name]
          self.args = arg_array.join("/")
      end

      def check_errors
        return t('magic.invalid_name') if !caster
      end

      def handle
      #Reading Config
        roll = Global.read_config("spells", self.spell, "roll")
        heal_points = Global.read_config("spells", self.spell, "heal_points")

        if self.caster.combat
          if self.caster_combat.is_ko
            client.emit_failure t('magic.spell_ko')
          elsif (!caster_combat.is_npc? &&  !Magic.find_potion_has(caster, self.potion_name) )
              client.emit_failure t('magic.dont_have_potion')
          else
            FS3Combat.set_action(client, enactor, enactor.combat, caster_combat, FS3Combat::PotionAction, self.spell)

          end

        elsif
          #Roll NonCombat
          if roll
            Magic.potion_noncombat_spell(self.caster, self.spell)
          elsif heal_points
            Magic.potion_non_combat_heal(self.caster, self.spell)
          else
            client.emit_failure t('magic.not_in_combat')
          end

        end

        Magic.handle_potions_used_achievement(caster)
      end







    end
  end
end

module AresMUSH
  module Custom
    class PotionUseWithTargetCmd
    #potion/use <potion>=<target>
      include CommandHandler
      attr_accessor :potion, :potion_name, :potion, :roll, :spell, :caster, :target, :caster_combat, :target_combat, :target_name, :action_args

      def parse_args
        if (cmd.args =~ /\//)
          #Forcing NPC or PC to cast
          args = cmd.parse_args( /(?<arg1>[^\/]+)\/(?<arg2>[^\=]+)\=?(?<arg3>.+)?/)
          combat = enactor.combat
          caster_name = titlecase_arg(args.arg1)
          self.spell = titlecase_arg(args.arg2)
          self.potion_name = titlecase_arg(args.arg2)
          self.target_name = titlecase_arg(args.arg3)
          #Returns char or NPC
          self.caster = FS3Combat.find_named_thing(caster_name, enactor)
          self.target = FS3Combat.find_named_thing(target_name, enactor)

          #Returns combatant
          if enactor.combat
            self.target_combat = combat.find_combatant(self.target_name)
            self.caster_combat = combat.find_combatant(caster_name)
          end

        else
          #Enactor casts
          args = cmd.parse_args(/(?<arg1>[^\=]+)\=?(?<arg2>.+)?/)
          self.potion_name = titlecase_arg(args.arg1)
          self.spell = titlecase_arg(args.arg1)
          self.target_name = titlecase_arg(args.arg2)

          #Returns char or NPC
          caster_name = enactor.name
          self.caster = enactor
          self.target = FS3Combat.find_named_thing(self.target_name, self.caster)

          #Returns combatant
          if enactor.combat
            combat = enactor.combat
            self.caster_combat = enactor.combatant
            self.target_combat = combat.find_combatant(target_name)
          end

        end
        arg_array = [target_name, potion_name]
        self.action_args = arg_array.join("/")

      end

      def check_errors
        # return t('custom.already_cast') if (enactor.combat && Custom.already_cast(self.caster_combat))
        return t('custom.invalid_name') if !self.target
      end

      def handle
      #Reading Config
        roll = Global.read_config("spells", self.spell, "roll")
        heal_points = Global.read_config("spells", self.spell, "heal_points")
        if self.caster.combat
          if self.caster_combat.is_ko
            client.emit_failure t('custom.spell_ko')
          elsif (!caster_combat.is_npc? &&  !Custom.find_potion_has(caster, self.potion_name))
            client.emit_failure t('custom.dont_have_potion')
          else
            FS3Combat.set_action(client, enactor, enactor.combat, caster_combat, FS3Combat::PotionTargetAction, self.action_args)
          end

        else
          if heal_points
            if Custom.knows_spell?(caster, self.spell)
              Custom.potion_non_combat_heal_with_target(self.caster, self.target, self.spell)
            else
              client.emit_failure t('custom.dont_know_spell')
            end
          else
            client.emit_failure t('custom.not_in_combat')
          end
        end
        Custom.handle_potions_used_achievement(caster)


      end







    end
  end
end

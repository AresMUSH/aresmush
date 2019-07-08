module AresMUSH
  module Magic
    class PotionUseCmd
    #potion/use <potion>
      include CommandHandler
      attr_accessor :potion, :potion_name, :caster, :target, :target_name_arg

      # Using 'caster' even though it should probably be user or something just for variable consistency with helpers.
      def parse_args
         args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2)
         self.caster = enactor
         self.potion_name = titlecase_arg(args.arg1)
         self.potion = Magic.find_potion_has(caster, self.potion_name)
         self.target_name_arg = titlecase_arg(args.arg2)
         if target_name_arg
           self.target = Character.named(target_name_arg)
         else
           self.target = self.caster
         end

        #   if (cmd.args =~ /\//)
        #   #Forcing NPC or PC to use potion
        #   args = cmd.parse_args(/(?<arg1>[^\/]+)\/(?<arg2>[^\+]+)/)
        #   combat = enactor.combat
        #   caster_name = titlecase_arg(args.arg1)
        #   #Returns char or NPC
        #   self.caster = FS3Combat.find_named_thing(caster_name, enactor)
        #   #Returns combatant
        #   if enactor.combat
        #     self.caster_combat = combat.find_combatant(caster_name)
        #     self.potion_name = titlecase_arg(args.arg2)
        #   end
        # else
        #    args = cmd.parse_args(/(?<arg1>[^\+]+)\+?(?<arg2>.+)?/)
        #    #Returns char or NPC
        #    caster_name = enactor.name
        #    self.caster = enactor
        #    self.potion_name = titlecase_arg(args.arg1)
        #
        #    #Returns combatant
        #    if enactor.combat
        #      self.caster_combat = enactor.combatant
        #    end
        #   end
        #   self.potion = Magic.find_potion_has(caster, self.potion_name)
        #   Global.logger.debug "Potion: #{potion} #{potion.name}"
        #   arg_array = [caster_name, potion_name]
        #   self.args = arg_array.join("/")
      end

      def check_errors
        return t('magic.invalid_name') if (self.target_name_arg && !self.target)
        return t('magic.dont_have_potion') if !self.potion
        return t('magic.use_combat_potion') if caster.combat
      end

      def handle
        if target_name_arg
          target_name = self.target.name
        else
          target_name = nil
        end

        heal_points = Global.read_config("spells", self.potion_name, "heal_points")

        if heal_points
          message = Magic.cast_non_combat_heal(self.caster, target_name, self.potion_name, mod = nil, is_potion = true)
        else
          message = Magic.cast_noncombat_spell(self.caster, target_name, self.potion_name, mod = nil, is_potion = true)
        end

        self.caster.room.emit message
        if self.caster.room.scene
          Scenes.add_to_scene(self.caster.room.scene, message)
        end

        self.potion.delete
        Magic.handle_potions_used_achievement(caster)
      end

    end
  end
end

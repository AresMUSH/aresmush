module AresMUSH
  module Magic
    class PotionUseCmd
    #potion/use <potion>/[<target>]
      include CommandHandler
      attr_accessor :potion, :potion_name, :caster, :target, :target_name_arg

      # Using 'caster' even though it should probably be user or something just for variable consistency with helpers.
      def parse_args
         args = cmd.parse_args(ArgParser.arg1_slash_optional_arg2)
         self.caster = enactor
         self.potion_name = titlecase_arg(args.arg1)
         self.potion = Magic.find_potion_has(caster, self.potion_name)
         self.target_name_arg = titlecase_arg(args.arg2)
         if target_name_arg
           self.target = Character.named(target_name_arg)
         else
           self.target = self.caster
         end
      end

      def check_errors
        return t('magic.use_combat_potion') if caster.combat
        return "That is the wrong format. Try potion/use <potion>/<target>." if (cmd.args =~ /\=/)
        return t('magic.dont_have_potion') if !self.potion
        return t('magic.invalid_name') if (self.target_name_arg && !self.target)
        wound = FS3Combat.worst_treatable_wound(self.target)
        heal_points = Global.read_config("spells", self.potion_name, "heal_points")
        return t('magic.no_healable_wounds', :target => target.name) if (wound.blank? && heal_points)
      end

      def handle
        if target_name_arg
          target_name = self.target.name
        else
          target_name = nil
        end

        heal_points = Global.read_config("spells", self.potion_name, "heal_points")

        if heal_points
          message = Magic.cast_non_combat_heal(self.caster.name, target_name, self.potion_name, mod = nil, is_potion = true)
        elsif Magic.spell_shields.include?(self.potion_name)
          school = "Magic"
          cast_mod = FS3Skills.ability_rating(caster, "Magic") * 2
          roll = self.caster.roll_ability(school, cast_mod)[:successes]
          message = Magic.cast_noncombat_shield(self.caster, self.caster.name, target_name, self.potion_name, mod = nil, roll, is_potion = true)
        else
          message = Magic.cast_noncombat_spell(self.caster.name, target_name, self.potion_name, mod = nil, result = roll, is_potion = true)
        end
        message.each do |message|
          self.caster.room.emit message
          if self.caster.room.scene
            Scenes.add_to_scene(self.caster.room.scene, message)
          end
        end

        self.potion.delete
        Magic.handle_potions_used_achievement(caster)
      end

    end
  end
end

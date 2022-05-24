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
           self.target_name_arg = enactor.name
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
        targets = Magic.parse_spell_targets(target_name_arg, self.potion_name)

        #Checking errors for each target.
        error =  Magic.target_errors(enactor, targets, self.potion_name)
        if error then return client.emit_failure error end

        message = Magic.cast_noncombat_spell(self.caster.name, targets, self.potion_name, mod = nil, result = 2, using_potion = true)

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

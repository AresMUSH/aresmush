module AresMUSH
  module Magic
    class SpellCastCmd
    #spell/cast <spell>
      include CommandHandler
      attr_accessor :name, :spell, :spell_list, :caster, :args, :mod, :target, :target_name_arg, :target_name

      def parse_args
      self.caster = enactor

      args = cmd.parse_args(/(?<spell>[a-zA-Z\s]+\w)\s*(?<mod>[+\-]\s*\d+)?(\/(?<target>.*))?/)
      self.spell = titlecase_arg(args.spell)
      self.mod = args.mod
      self.target_name_arg = titlecase_arg(args.target)
      self.target = Character.named(self.target_name_arg)

      if !self.target_name_arg
        target_name = nil
        self.target = enactor
      else
        self.target_name = self.target_name_arg
      end
    end

      def check_errors
        return t('magic.use_combat_spell') if caster.combat
        return "That is the wrong format. Try spell/cast <spell>/<target>." if (cmd.args =~ /\=/)
        spell_list = Global.read_config("spells")
        return t('magic.not_spell') if !spell_list.include?(self.spell)
        return t('magic.dont_know_spell') if (Magic.knows_spell?(caster, self.spell) == false && Magic.item_spell(caster) != spell)
        return nil
      end

      def handle
        heal_points = Global.read_config("spells", self.spell, "heal_points")
        success = Magic.roll_noncombat_spell_success(self.caster, self.spell, self.mod)

        if success == "%xgSUCCEEDS%xn"
          if heal_points
            message = Magic.cast_non_combat_heal(self.caster, self.target_name, self.spell, self.mod)
          elsif Magic.spell_shields.include?(self.spell)
            message = Magic.cast_noncombat_shield(self.caster, self.target, self.spell, self.mod)
          else
            message = Magic.cast_noncombat_spell(self.caster, self.target_name, self.spell, self.mod)
          end
          Magic.handle_spell_cast_achievement(self.caster)
        else
          message = t('magic.casts_noncombat_spell', :name => caster.name, :spell => spell, :mod => mod, :succeeds => success)
        end
        self.caster.room.emit message

        if self.caster.room.scene
          Scenes.add_to_scene(self.caster.room.scene, message)
        end
      end

    end
  end
end

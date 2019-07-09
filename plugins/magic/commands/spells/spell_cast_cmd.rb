module AresMUSH
  module Magic
    class SpellCastCmd
    #spell/cast <spell>
      include CommandHandler
      attr_accessor :name, :spell, :spell_list, :caster, :args, :mod, :target, :target_name_arg

      def parse_args
      self.caster = enactor

      args = cmd.parse_args((?<spell>[a-zA-Z\s]+?)\s*(?<mod>[+\-]\s*\d+)?(/(?<target>.*))?)
      self.spell = args.spell
      self.mod = args.mod
      self.target = args.target


        Global.logger.debug "Target!: #{self.target.name}"
        Global.logger.debug "Spell: #{self.spell}"
        # Global.logger.debug "Mod: #{self.mod}"


      # if (cmd.args =~ /\//)
      #   #With a target
      #   args = cmd.parse_args(/(?<arg1>[^\/]+)\/(?<arg2>[^\+]+)/)
      #   spell_str = titlecase_arg(args.arg1)
      #   target_name = titlecase_arg(args.arg2)
      #   self.target = Character.named(target_name)
      #   spell_args = cmd.parse_args(/(?<arg1>[^\+\-]+)(?<arg2>.+)?/)
      #   self.spell = titlecase_arg(spell_args.arg1)
      #   self.mod = spell_args.arg2
      #   Global.logger.debug "Target!: #{self.target.name}"
      #   Global.logger.debug "Spell: #{self.spell}"
      #   Global.logger.debug "Mod: #{self.mod}"
      # else
      #   args = cmd.parse_args(/(?<arg1>[^\+\-]+)(?<arg2>.+)?/)
      #   self.spell = titlecase_arg(args.arg1)
      #   self.mod = args.arg2
      # end
    end



      def check_errors
        spell_list = Global.read_config("spells")
        return t('magic.not_spell') if !spell_list.include?(self.spell)
        return t('magic.dont_know_spell') if (Magic.knows_spell?(caster, self.spell) == false && Magic.item_spell(caster) != spell)
        return nil
      end

      def handle
      #Reading Config Files
        heal_points = Global.read_config("spells", self.spell, "heal_points")
        success = Magic.roll_noncombat_spell_success(self.caster, self.spell, self.mod)

        if success == "%xgSUCCEEDS%xn"
          if heal_points
            message = Magic.cast_non_combat_heal(self.caster, self.caster.name, self.spell, self.mod)
          elsif Magic.spell_shields.include?(self.spell)
            message = Magic.cast_noncombat_shield(self.caster, self.caster, self.spell, self.mod)
          else
            message = Magic.cast_noncombat_spell(self.caster, nil, self.spell, self.mod)
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

module AresMUSH
  module Magic
    class SpellCastCmd
    #spell/cast <spell>
      include CommandHandler
      attr_accessor :name, :spell, :spell_list, :has_target, :args, :mod, :target, :target_name_string, :target_name

      def parse_args
        args = cmd.parse_args(/(?<spell>[^+\-\/]+[^+\-\/\s])\s*(?<mod>[+\-]\s*\d+)?(\/(?<target>.*))?/)
        self.spell = titlecase_arg(args.spell)
        puts "SPELL: #{self.spell}"
        self.mod = args.mod
        if !args.target
          self.target_name_string = enactor.name
          self.has_target = false
        else
          self.target_name_string = titlecase_arg(args.target)
          self.has_target = true
        end
      end

      def check_errors
        return t('magic.use_combat_spell') if enactor.combat
        spell_list = Global.read_config("spells")
        return t('magic.not_spell') if !spell_list.include?(self.spell)
        return t('magic.dont_know_spell') if (Magic.knows_spell?(enactor, self.spell) == false && !Magic.item_spells(enactor).include?(spell))
        target_num = Global.read_config("spells", self.spell, "target_num")
        return t('magic.doesnt_use_target') if (self.has_target && !target_num)
        return "That is the wrong format. Try spell/cast <spell>/<target>." if (cmd.args =~ /\=/)
        return nil
      end

      def handle
        heal_points = Global.read_config("spells", self.spell, "heal_points")
        print_names = Magic.print_target_names(self.target_name_string)
        success = Magic.roll_noncombat_spell_success(enactor.name, self.spell, self.mod, dice = nil)

        if success[:succeeds] == "%xgSUCCEEDS%xn"
          if !self.has_target
            self.target_name_string = nil
          end
          if heal_points
            message = Magic.cast_non_combat_heal(enactor.name, self.target_name_string, self.spell, self.mod)
          elsif Magic.spell_shields.include?(self.spell)
            message = Magic.cast_noncombat_shield(enactor, enactor.name, self.target_name_string, self.spell, self.mod, success[:result])
          else
            message = Magic.cast_noncombat_spell(enactor.name, self.target_name_string, self.spell, self.mod, success[:result])
          end
          Magic.handle_spell_cast_achievement(enactor)
        else
          if !self.has_target
            message = [t('magic.casts_spell', :name => enactor.name, :spell => spell, :mod => mod, :succeeds => success[:succeeds])]
          else
            message = [t('magic.casts_spell_on_target', :name => enactor.name, :spell => spell, :mod => mod, :target => print_names, :succeeds => success[:succeeds])]
          end
        end
        message.each do |msg|
          enactor.room.emit msg
          if enactor.room.scene
            Scenes.add_to_scene(enactor.room.scene, msg)
          end
        end

      end

    end
  end
end

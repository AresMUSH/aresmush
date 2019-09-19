module AresMUSH
  module Magic
    class SpellNPCCmd
    #spell/npc npc/dice=spell/target
      include CommandHandler
      attr_accessor :name, :spell, :spell_list, :has_target, :args, :mod, :target, :target_name_string, :target_name, :npc, :dice

      def parse_args
        args = cmd.parse_args(/(?<npc>.+?)\/(?<dice>\d+)=(?<spell>.+?)\/(?<target>.+)/)
        self.spell = titlecase_arg(args.spell)
        self.npc = titlecase_arg(args.npc)
        self.dice = args.dice.to_i

        if !args.target
          self.target_name_string = self.npc
          self.has_target = false
        else
          self.target_name_string = titlecase_arg(args.target)
          self.has_target = true
        end
        Global.logger.debug "#{self.npc} rolling #{self.dice} dice to cast #{self.spell} on #{self.target_name_string}"
      end

      def check_errors
        return t('magic.use_combat_spell') if enactor.combat
        spell_list = Global.read_config("spells")
        return t('magic.not_spell') if !spell_list.include?(self.spell)
        target_optional = Global.read_config("spells", self.spell, "target_optional")
        return t('magic.doesnt_use_target') if (self.has_target && target_optional.nil?)
        return nil
      end

      def handle
        heal_points = Global.read_config("spells", self.spell, "heal_points")
        print_names = Magic.print_target_names(self.target_name_string)
        success = Magic.roll_noncombat_spell_success(self.npc, self.spell, mod = nil, self.dice)

        if success[:succeeds] == "%xgSUCCEEDS%xn"
          if heal_points
            message = Magic.cast_non_combat_heal(self.npc, self.target_name_string, self.spell, mod = nil)
          elsif Magic.spell_shields.include?(self.spell)
            message = Magic.cast_noncombat_shield("npc", self.npc, self.target_name_string, self.spell, mod = nil, success[:result])
          else
            if !self.has_target
              self.target_name_string = nil
            end
            message = Magic.cast_noncombat_spell(self.npc, self.target_name_string, self.spell, mod = nil, success[:result])
          end
        else
          if !self.has_target
            message = [t('magic.casts_spell', :name => self.npc, :spell => spell, :mod => mod, :succeeds => success[:succeeds])]
          else
            if print_names == "no_target"
              print_names = self.npc
            end
            message = [t('magic.casts_spell_on_target', :name => self.npc, :spell => spell, :mod => mod, :target => print_names, :succeeds => success[:succeeds])]
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

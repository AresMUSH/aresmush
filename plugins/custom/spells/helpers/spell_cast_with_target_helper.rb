module AresMUSH
  module Custom



    def self.cast_noncombat_roll_spell_with_target(caster, target, spell, mod)
      enactor_room = caster.room
      success = Custom.roll_noncombat_spell_success(caster, spell, mod)
      enactor_room.emit t('custom.casts_noncombat_spell_with_target', :name => caster.name, :target => target.name, :spell => spell, :mod => mod, :succeeds => success)
    end



    def self.cast_non_combat_heal_with_target(caster, target, spell, mod)
      succeeds = Custom.roll_noncombat_spell_success(caster, spell, mod)
      room = caster.room
      if succeeds == "%xgSUCCEEDS%xn"
        wound = FS3Combat.worst_treatable_wound(target)
        heal_points = Global.read_config("spells", spell, "heal_points")
        if (wound)
          FS3Combat.heal(wound, heal_points)
          room.emit t('custom.cast_heal', :name => caster.name, :spell => spell, :succeeds => succeeds, :target => target.name, :points => heal_points)
        else
          room.emit t('custom.cast_heal_no_effect', :name => caster.name, :spell => spell, :succeeds => succeeds, :target => target.name)
        end
      else
        room.emit t('custom.casts_spell', :name => caster.name, :spell => spell, :succeeds => succeeds)
      end
    end




  end
end

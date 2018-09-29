module AresMUSH
  module Custom

    def self.cast_multi_heal(caster, caster_combat, target_string, spell)
      succeeds = Custom.roll_combat_spell_success(caster_combat, spell)
      if succeeds == "%xgSUCCEEDS%xn"
        targets = Custom.parse_spell_targets(target_string, caster.combat)
        targets.each do |t|
          target = FS3Combat.find_named_thing(t, caster)
          return t('custom.cant_heal_dead') if (target.dead)
          wound = FS3Combat.worst_treatable_wound(target)
          heal_points = Global.read_config("spells", spell, "heal_points")

          if (wound)
            FS3Combat.heal(wound, heal_points)
            FS3Combat.emit_to_combat caster.combat, t('custom.cast_heal', :name => caster.name, :spell => spell, :succeeds => succeeds, :target => target.name, :points => heal_points), nil, true
          else
            FS3Combat.emit_to_combat caster.combat, t('custom.cast_heal_no_effect', :name => caster.name, :spell => spell, :succeeds => succeeds, :target => target.name), nil, true
          end
        end
      else
        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell, :succeeds => succeeds), nil, true
      end
    end

    # def self.cast_multi_subdue(caster, caster_combat, target_string, spell)
    #   succeeds = Custom.roll_combat_spell_success(caster_combat, spell)
    #   if succeeds == "%xgSUCCEEDS%xn"
    #     targets = Custom.parse_spell_targets(target_string, caster.combat)
    #     targets.each do |t|
    #       target = FS3Combat.find_named_thing(t, caster)

    def self.cast_multi_revive(caster, caster_combat, target_string, spell)
      succeeds = Custom.roll_combat_spell_success(caster_combat, spell)
      if succeeds == "%xgSUCCEEDS%xn"
        targets = Custom.parse_spell_targets(target_string, caster.combat)
        targets.each do |t|
          combat = caster.combat
          target = FS3Combat.find_named_thing(t, caster)
          target_combat = combat.find_combatant(t)
          return t('custom.not_ko', :target => self.target.name) if !target_combat.is_ko
          target_combat.update(is_ko: false)
          FS3Combat.emit_to_combat caster_combat.combat, t('custom.cast_res', :name => caster_combat.name, :spell => spell, :succeeds => succeeds, :target => target_combat.name), nil, true
          FS3Combat.emit_to_combatant target_combat, t('custom.been_resed', :name => caster_combat.name), nil, true
        end
      else
        FS3Combat.emit_to_combat caster.combat, t('custom.casts_spell', :name => caster.name, :spell => spell, :succeeds => succeeds), nil, true
      end
    end

    def self.cast_multi_roll_spell(caster, caster_combat, target_string, spell)
      succeeds = Custom.roll_combat_spell_success(caster_combat, spell)
      client = Login.find_client(caster_combat)
      if succeeds == "%xgSUCCEEDS%xn"
        targets = Custom.parse_spell_targets(target_string, caster.combat)
        targets.each do |t|
          target = FS3Combat.find_named_thing(t, caster)
          FS3Combat.emit_to_combat caster_combat.combat, t('custom.casts_spell_on_target', :name => caster_combat.name, :spell => spell, :target => target.name, :succeeds => succeeds), nil, true
        end
      else
        FS3Combat.emit_to_combat caster_combat.combat, t('custom.casts_spell', :name => caster_combat.name, :spell => spell, :succeeds => succeeds), nil, true
      end
    end

    def self.cast_multi_noncombat_roll_spell(caster, target_name, spell)
      success = Custom.roll_noncombat_spell_success(caster, spell)
      names_array = target_name.split(" ")
      names = []
      names_array.each do |name|
        target = FS3Combat.find_named_thing(name, caster)
         if !target
           client.emit_failure t('custom.invalid_name')
         else
           names = names.push target.name
         end
      end
      targets = names.join(", ")
      enactor_room = caster.room
      enactor_room.emit t('custom.casts_noncombat_spell_with_target', :name => caster.name, :target => targets, :spell => spell, :succeeds => success)
    end


  end
end

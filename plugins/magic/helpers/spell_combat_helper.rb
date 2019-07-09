module AresMUSH
  module Magic

    def self.roll_combat_spell(char, combatant, school, mod)
      accuracy_mod = FS3Combat.weapon_stat(combatant.weapon, "accuracy")
      special_mod = combatant.attack_mod
      damage_mod = combatant.total_damage_mod
      stance_mod = combatant.attack_stance_mod
      stress_mod = combatant.stress
      attack_luck_mod = (combatant.luck == "Attack") ? 3 : 0
      spell_luck_mod = (combatant.luck == "Spell") ? 3 : 0
      distraction_mod = combatant.distraction
      spell_mod = combatant.spell_mod
      if !combatant.is_npc?
        item_spell_mod = Magic.item_spell_mod(combatant.associated_model)
      else
        item_spell_mod = 0
      end


      combatant.log "Spell roll for #{combatant.name} school=#{school} mod=#{mod} spell_mod=#{spell_mod} item_spell_mod=#{item_spell_mod} accuracy=#{accuracy_mod} damage=#{damage_mod} stance=#{stance_mod} attack_luck=#{attack_luck_mod} spell_luck=#{spell_luck_mod} stress=#{stress_mod} special=#{special_mod} distract=#{distraction_mod}"

      mod = mod + item_spell_mod.to_i + spell_mod.to_i + accuracy_mod.to_i + damage_mod.to_i  + stance_mod.to_i  + attack_luck_mod.to_i  + spell_luck_mod.to_i - stress_mod.to_i  + special_mod.to_i - distraction_mod.to_i

      successes = combatant.roll_ability(school, mod)
      return successes
    end

    def self.cast_mind_shield(combatant, target, spell, rounds)
      shield_strength = combatant.roll_ability("Spirit")
      target.update(mind_shield: shield_strength)
      target.update(mind_shield_counter: rounds)

      combatant.log "Setting #{combatant.name}'s Mind Shield to #{shield_strength}"
      message = [t('magic.cast_shield', :name => combatant.name, :spell => spell, :mod => "", :succeeds => "%xgSUCCEEDS%xn", :target =>  target.name, :type => "psionic")]
      return message
    end

    def self.cast_endure_fire(combatant, target, spell, rounds)
      shield_strength = combatant.roll_ability("Fire")
      target.update(target: shield_strength)
      target.update(endure_fire_counter: rounds)
      combatant.log "Setting #{target.name}'s Endure Fire to #{shield_strength}"
      message = [t('magic.cast_shield', :name => combatant.name, :spell => spell, :mod => "", :succeeds => succeeds, :target =>  target.name, :type => "fire")]
      return message
    end


  end
end

module AresMUSH
  module Death 

    def self.new_turn(combatant)
      if (combatant.combat.is_real && combatant.is_ko && !combatant.is_npc?)
        Death.death_counter(combatant)
      end
    end

    def self.zero(combatant)
      combatant.update(death_count: 0)
    end

    def self.one(combatant)
      combatant.update(death_count: 1)
    end

    def self.death_counter(combatant)
      death_count = combatant.death_count
      if death_count == 1
        combatant.update(death_count: 2)
        FS3Combat.emit_to_combat(combatant.combat, t('death.one_death', :name => combatant.name), npcmaster = nil, add_to_scene = true)
      elsif death_count == 2
        combatant.update(death_count: 3)
        FS3Combat.emit_to_combat(combatant.combat, t('death.two_death', :name => combatant.name), npcmaster = nil, add_to_scene = true)
      elsif death_count == 3
        combatant.update(death_count: 4)
        FS3Combat.emit_to_combat(combatant.combat, t('death.died', :name => combatant.name), npcmaster = nil, add_to_scene = true)
        combatant.character.update(dead: true)
        Death.handle_has_died_achievement(combatant.associated_model)
      end
    end

    def self.treat_dying(healer_name, patient)
      if patient.combat && patient.combatant.is_ko
        patient.combatant.update(death_count: 0)
        t('death.treat_success_not_dying', :healer => healer_name, :patient => patient.name)
      else
        t('fs3combat.treat_success', :healer => healer_name, :patient => patient.name)
      end
    end

    def self.undead(character)
      if character.combatant
        character.combatant.update(death_count: 0  )
        character.combatant.update(is_ko: false)
      end
      character.update(dead: false )
    end

    def self.handle_has_died_achievement(char)
      char.update(has_died: char.has_died + 1)
      [ 1, 10, 20, 50, 100 ].each do |count|
        if (char.has_died >= count)
          # if (count == 1)
          #   message = "Has died."
          # else
          #   message = "Has died #{count} times."
          # end
          Achievements.award_achievement(char, "has_died", count)
        end
      end
    end


  end
end

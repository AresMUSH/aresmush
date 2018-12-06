module AresMUSH
  module Custom

    def self.death_counter(combatant)
      death_count = combatant.death_count
      if death_count == 1
        combatant.update(death_count: 2 )
        FS3Combat.emit_to_combat(combatant.combat, t('custom.one_death', :name => combatant.name), npcmaster = nil, add_to_scene = true)
      elsif death_count == 2
        combatant.update(death_count: 3 )
        FS3Combat.emit_to_combat(combatant.combat, t('custom.two_death', :name => combatant.name), npcmaster = nil, add_to_scene = true)
      elsif death_count == 3
        combatant.update(death_count: 4  )
        FS3Combat.emit_to_combat(combatant.combat, t('custom.died', :name => combatant.name), npcmaster = nil, add_to_scene = true)
        combatant.character.update(dead: true)
        Custom.handle_has_died_achievement(enactor)
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
          if (count == 1)
            message = "Has died."
          else
            message = "Has died #{count} times."
          end
          Achievements.award_achievement(char, "has_died_#{count}", 'death', message)
        end
      end
    end


  end
end

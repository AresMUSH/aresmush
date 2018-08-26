module AresMUSH
  module Custom

    def self.death_counter(combatant)
      death_count = combatant.death_count
      if death_count == 1
        combatant.update(death_count: 2 )
        FS3Combat.emit_to_combat combatant.combat, t('custom.one_death', :name => combatant.name)
      elsif death_count == 2
        combatant.update(death_count: 3 )
        FS3Combat.emit_to_combat combatant.combat, t('custom.two_death', :name => combatant.name)
      elsif death_count == 3
        combatant.update(death_count: 4  )
        FS3Combat.emit_to_combat combatant.combat, t('custom.died', :name => combatant.name)
        combatant.update(dead: true )
      end
    end



  end
end

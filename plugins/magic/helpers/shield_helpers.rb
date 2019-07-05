module AresMUSH
  module Magic

    def self.spell_shields
      ["Mind Shield", "Endure Fire", "Endure Cold"]
    end

    def self.shields_expire (char)
      room = char.room
      if (char.mind_shield > 0)
        room.emit_ooc t('magic.shield_wore_off', :name => char.name, :shield => "Mind Shield")
      end

      if (char.endure_fire > 0)
        room.emit_ooc t('magic.shield_wore_off', :name => char.name, :shield => "Endure Fire")
      end

      if (char.endure_cold > 0)
        room.emit_ooc t('magic.shield_wore_off', :name => char.name, :shield => "Endure Cold")
      end

        char.update(mind_shield: 0)
        char.update(endure_fire: 0)
        char.update(endure_cold: 0)
    end

  end
end

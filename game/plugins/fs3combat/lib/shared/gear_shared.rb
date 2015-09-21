module AresMUSH
  module FS3Combat
    def self.weapons
      Global.read_config("fs3combat", "weapons")
    end
    
    def self.weapon(name)
      key = FS3Combat.weapons.keys.select { |k| k.upcase == name.upcase}.first
      key ? FS3Combat.weapons[key] : nil
    end

    def self.weapon_stat(name, stat)
      weapon = FS3Combat.weapon(name)
      weapon ? weapon[stat] : nil
    end
    
    def self.weapon_is_stun?(name)
      FS3Combat.weapon_stat(name, "damage_type").titleize == "Stun"
    end
    
    def self.armors
      Global.read_config("fs3combat", "armor")
    end
    
    def self.armor(name)
      key = FS3Combat.armors.keys.select { |k| k.upcase == name.upcase}.first
      key ? FS3Combat.armors[key] : nil
    end

    def self.vehicles
      Global.read_config("fs3combat", "vehicles")
    end

    def self.vehicle(name)
      key = FS3Combat.vehicles.keys.select { |k| k.upcase == name.upcase}.first
      key ? FS3Combat.vehicles[key] : nil
    end
    
    def self.hitlocs
      Global.read_config("fs3combat", "hitloc")
    end
    
    def self.hitloc(name)
      key = FS3Combat.hitlocs.keys.select { |k| k.upcase == name.upcase}.first
      key ? FS3Combat.hitlocs[key] : nil
    end
    
    def self.gear_detail(info)
      if (info.class == Array)
        return info.join(", ")
      elsif (info.class == Hash)
        return info.map { |k, v| "#{k}: #{v}"}.join("%R                     ")
      elsif (info.class == TrueClass || info.class == FalseClass)
        return info ? t('global.y') : t('global.n')
      else
        return info
      end
    end
    
    def self.set_weapon(client, name, weapon, specials = nil)
      FS3Combat.with_a_combatant(name, client) do |combat, combatant|        
        combatant.weapon = weapon ? weapon.titleize : nil
        combatant.weapon_specials = specials ? specials.map { |s| s.titleize } : nil
        combatant.ammo = FS3Combat.weapon_stat(weapon, "ammo")
        combatant.action.destroy!
        combatant.save
        specials_text = combatant.weapon_specials ? combatant.weapon_specials.join(',') : t('global.none')
        message = t('fs3combat.weapon_changed', :name => name, 
          :weapon => combatant.weapon, 
          :specials => specials_text)
        combat.emit message, FS3Combat.npcmaster_text(name, client.char)
      end
    end
    
    def self.set_armor(client, name, armor)
      FS3Combat.with_a_combatant(name, client) do |combat, combatant|        
        combatant.armor = armor ? armor.titleize : nil
        combatant.save
        message = t('fs3combat.armor_changed', :name => name, :armor => combatant.armor)
        combat.emit message, FS3Combat.npcmaster_text(name, client.char)
      end
    end
  end
end
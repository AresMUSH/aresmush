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

    def self.armor_stat(name, stat)
      a = FS3Combat.armor(name)
      a ? a[stat] : nil
    end

    def self.vehicles
      Global.read_config("fs3combat", "vehicles")
    end

    def self.vehicle(name)
      key = FS3Combat.vehicles.keys.select { |k| k.upcase == name.upcase}.first
      key ? FS3Combat.vehicles[key] : nil
    end
    
    def self.vehicle_stat(name, stat)
      v = FS3Combat.vehicle(name)
      v ? v[stat] : nil
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
    
    def self.set_default_gear(enactor, combatant, type)
      weapon = FS3Combat.combatant_type_stat(type, "weapon")
      if (weapon)
        specials = FS3Combat.combatant_type_stat(type, "weapon_specials")
        FS3Combat.set_weapon(enactor, combatant, weapon, specials)
      end
      
      armor = FS3Combat.combatant_type_stat(type, "armor")
      if (armor)
        FS3Combat.set_armor(enactor, combatant, armor)
      end
    end
    
    def self.set_weapon(enactor, combatant, weapon, specials = nil)
      combatant.weapon = weapon ? weapon.titleize : nil
      combatant.weapon_specials = specials ? specials.map { |s| s.titleize } : nil
      combatant.ammo = FS3Combat.weapon_stat(weapon, "ammo")
      combatant.action = nil
      combatant.save
      specials_text = combatant.weapon_specials ? combatant.weapon_specials.join(',') : t('global.none')
      message = t('fs3combat.weapon_changed', :name => combatant.name, 
        :weapon => combatant.weapon, 
        :specials => specials_text)
      combatant.combat.emit message, FS3Combat.npcmaster_text(combatant.name, enactor)
    end
    
    def self.set_armor(enactor, combatant, armor)
      combatant.armor = armor ? armor.titleize : nil
      combatant.save
      message = t('fs3combat.armor_changed', :name => combatant.name, :armor => combatant.armor)
      combatant.combat.emit message, FS3Combat.npcmaster_text(combatant.name, enactor)
    end
  end
end
module AresMUSH
  module FS3Combat
    def self.weapons
      Global.read_config("fs3combat", "weapons")
    end
    
    def self.weapon(name)
      FS3Combat.weapons.select { |k, v| k.upcase == name.upcase}.values.first
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
      FS3Combat.armors.select { |k, v| k.upcase == name.upcase}.values.first
    end

    def self.armor_stat(name, stat)
      a = FS3Combat.armor(name)
      a ? a[stat] : nil
    end

    def self.vehicles
      Global.read_config("fs3combat", "vehicles")
    end

    def self.vehicle(name)
      FS3Combat.vehicles.select { |k, v| k.upcase == name.upcase}.values.first
    end
    
    def self.vehicle_stat(name, stat)
      v = FS3Combat.vehicle(name)
      v ? v[stat] : nil
    end
    
    def self.hitloc_charts
      Global.read_config("fs3combat", "hitloc")
    end
    
    def self.hitloc_chart_for_type(name)
      FS3Combat.hitloc_charts.select { |k, v| k.upcase == name.upcase}.values.first
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
      max_ammo = weapon ? FS3Combat.weapon_stat(weapon, "ammo") : 0
      combatant.update(weapon: weapon ? weapon.titleize : nil)
      combatant.update(weapon_specials: specials ? specials.map { |s| s.titleize } : nil)
      combatant.update(ammo: max_ammo)
      combatant.update(max_ammo: max_ammo)
      combatant.update(action_klass: nil)
      combatant.update(action_args: nil)

      specials_text = combatant.weapon_specials ? combatant.weapon_specials.join(',') : t('global.none')
      message = t('fs3combat.weapon_changed', :name => combatant.name, 
        :weapon => combatant.weapon, 
        :specials => specials_text)
      combatant.combat.emit message, FS3Combat.npcmaster_text(combatant.name, enactor)
    end
    
    def self.set_armor(enactor, combatant, armor)
      combatant.update(armor: armor ? armor.titleize : nil)
      message = t('fs3combat.armor_changed', :name => combatant.name, :armor => combatant.armor)
      combatant.combat.emit message, FS3Combat.npcmaster_text(combatant.name, enactor)
    end
  end
end
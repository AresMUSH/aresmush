module AresMUSH
  module FS3Combat
    def self.weapons
      Global.read_config("fs3combat", "weapons")
    end
    
    def self.weapon(name)
      name_upcase = name ? name.upcase : nil
      FS3Combat.weapons.select { |k, v| k.upcase == name_upcase}.values.first
    end

    def self.weapon_specials
      Global.read_config("fs3combat", "weapon specials")
    end
    
    def self.weapon_stat(name_with_specials, stat)
      return nil if !name_with_specials
      
      specials = FS3Combat.weapon_specials
      name = name_with_specials.before("+")
      weapon = FS3Combat.weapon(name)
      return nil if !weapon
      
      value = weapon[stat]
      return nil if !value
      
      special_names = name_with_specials.after("+")
      special_names = special_names ? special_names.split("+") : []
      
      special_names.each do |s|
        special = specials[s]
        next if !special
      
        special_value = special[stat]
        next if !special_value
      
        value = value + special_value
      end
      value
    end
    
    def self.weapon_is_stun?(name)
      FS3Combat.weapon_stat(name, "damage_type").titlecase == "Stun"
    end
    
    def self.armor_specials
      Global.read_config("fs3combat", "armor specials")
    end
    
    def self.armors
      Global.read_config("fs3combat", "armor")
    end
    
    def self.armor(name)
      FS3Combat.armors.select { |k, v| k.upcase == name.upcase}.values.first
    end

    def self.armor_stat(name_with_specials, stat)
      return nil if !name_with_specials
      name = name_with_specials.before("+")
      armor = FS3Combat.armor(name)
      return nil if !armor
      
      if (stat == "protection")
        value = armor[stat].dup
      else
        value = armor[stat]
      end
      return nil if !value
            
      # Special handling for protection because it's a hash itself
      special_names = name_with_specials.after("+")
      special_names = special_names ? special_names.split("+") : []
      specials = FS3Combat.armor_specials
      
      special_names.each do |s|
        special = specials[s]
        next if !special
        special_value = special[stat]
        next if !special_value

        if (stat == "protection")
          areas = value.keys | special_value.keys
          areas.each do |a|
            value[a] = (value[a] || 0) + (special_value[a] || 0)
          end
        else
          value = value + special_value
        end
      end
      
      value
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
    
    def self.mounts
      Global.read_config("fs3combat", "mounts")
    end
    
    def self.mount(name)
      FS3Combat.mounts.select { |k, v| k.upcase == name.upcase}.values.first
    end
    
    def self.mount_stat(name, stat)
      m = FS3Combat.mount(name)
      m ? m[stat] : nil
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
        specials = FS3Combat.combatant_type_stat(type, "armor_specials")
        FS3Combat.set_armor(enactor, combatant, armor, specials)
      end      
    end
    
    def self.set_weapon(enactor, combatant, weapon, specials = nil)
      weapon = weapon ? weapon.titlecase : "Unarmed"
      specials = specials ? specials.map { |s| s.titlecase }.uniq : []
      special_text = specials.empty? ? nil : "+#{specials.join("+")}"
      
      max_ammo = FS3Combat.weapon_stat("#{weapon}#{special_text}", "ammo") || 0
      prior_ammo = combatant.prior_ammo || {}
      
      current_ammo = max_ammo
      if (weapon && prior_ammo[weapon] != nil)
        current_ammo = prior_ammo[weapon]
      end
      if (combatant.weapon_name)
        prior_ammo[combatant.weapon_name] = combatant.ammo
        combatant.update(prior_ammo: prior_ammo)
      end
      combatant.update(weapon_name: weapon)
      combatant.update(weapon_specials: specials)
      combatant.update(ammo: current_ammo)
      combatant.update(max_ammo: max_ammo)
      combatant.update(action_klass: nil)
      combatant.update(action_args: nil)

      message = t('fs3combat.weapon_changed', :name => combatant.name, 
        :weapon => combatant.weapon)
      FS3Combat.emit_to_combat combatant.combat, message, FS3Combat.npcmaster_text(combatant.name, enactor)
    end
    
    def self.set_armor(enactor, combatant, armor, specials = nil)
      combatant.update(armor_name: armor ? armor.titlecase : nil)
      combatant.update(armor_specials: specials ? specials.map { |s| s.titlecase }.uniq : [])
      message = t('fs3combat.armor_changed', :name => combatant.name, :armor => combatant.armor)
      FS3Combat.emit_to_combat combatant.combat, message, FS3Combat.npcmaster_text(combatant.name, enactor)
    end
  end
end
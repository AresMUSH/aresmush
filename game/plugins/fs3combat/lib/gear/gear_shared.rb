module AresMUSH
  module FS3Combat
    def self.weapons
      Global.config['fs3combat']['weapons']
    end
    
    def self.weapon(name)
      key = FS3Combat.weapons.keys.select { |k| k.upcase == name.upcase}.first
      key ? FS3Combat.weapons[key] : nil
    end

    def self.weapon_stat(name, stat)
      weapon = FS3Combat.weapon(name)
      weapon ? weapon[stat] : nil
    end
    
    def self.armors
      Global.config['fs3combat']['armor']
    end
    
    def self.armor(name)
      key = FS3Combat.armors.keys.select { |k| k.upcase == name.upcase}.first
      key ? FS3Combat.armors[key] : nil
    end

    def self.vehicles
      Global.config['fs3combat']['vehicles']
    end

    def self.vehicle(name)
      key = FS3Combat.vehicles.keys.select { |k| k.upcase == name.upcase}.first
      key ? FS3Combat.vehicles[key] : nil
    end
    
    def self.hitlocs
      Global.config['fs3combat']['hitloc']
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
  end
end
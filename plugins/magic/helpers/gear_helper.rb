module AresMUSH
  module Magic

    def self.mundane_armors
      Global.read_config("fs3combat", "armor").select{ |k, a| !a['is_magic'] }
    end

    def self.mundane_weapons
      Global.read_config("fs3combat", "weapons").select { |k, w| !w['is_magic'] }
    end

    def self.mundane_weapon_specials
      FS3Combat.weapon_specials.select { |k, w| !w['is_magic'] }
    end

  end
end

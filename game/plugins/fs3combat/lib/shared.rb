module AresMUSH
  module FS3Combat
    # Array of hashes. 
    #    combats << {}
    #    combats[0][name] = {}   --- name can be PC or NPC
    #    combats[0][name][:ammo] == 14 --- sets a field
    mattr_accessor :combats
    
    def is_in_combat?(name)
      !FS3Combat.index.nil?
    end
    
    def self.index(name)
      FS3Combat.combats.index { |c| c.has_key?(name) }
    end
    
    def self.combat(name)
      index = FS3Combat.index(name)
      index ? FS3Combat.combats[index] : nil
    end
    
    def self.stats(name)
      combat = FS3Combat.combat(name)
      combat ? combat[name] : nil
    end
    
    def self.stat(name, stat_key)
      stats = FS3Combat.stats(name)
      stats ? stats[stat_key] : nil
    end
    
    def self.set_stat(name, stat_key, value)
      stats = FS3Combat.stats(name)
      stats[stat_key] = value
    end
    
    def self.add_to_combat(name, index, type)
      combat = FS3Combat.combats[index]
      combat[name] = { :type => type }
      
    end
  end
end
module AresMUSH
  module SWADE
    
    def self.derived_stat(char, config_setting)
      stats = Global.read_config("swade", config_setting)
      dice = []
      stats.each do |s|
        step = swade.find_ability_step(char, s)
        if (step)
          dice << step
        end
      end
      dice.join("+")
    end
    
    def self.parry(char)
      SWADE.derived_stat(char, "parry")
    end
    
    def self.toughness(char)
      SWADE.derived_stat(char, "toughness")
    end
  end
end
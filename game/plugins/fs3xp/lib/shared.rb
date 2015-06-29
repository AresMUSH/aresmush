module AresMUSH
  module FS3XP
    def self.can_manage_xp?(actor)
      actor.has_any_role?(Global.read_config("fs3xp", "roles", "can_manage_xp"))
    end
    
    def self.cost_for_rating(new_rating)
      config = Global.read_config("fs3xp", "skill_costs")
      return config[new_rating] if config.has_key?(new_rating)
      raise "XP Cost Not Defined for #{new_rating}!"
    end
    
    def self.days_between_xp_raises
      Global.read_config("fs3xp", "days_between_xp_raises")
    end
    
    def self.check_raise_frequency(char)
      return nil if char.last_xp_spend.nil?

      time_to_go = (FS3XP.days_between_xp_raises * 86400) - (Time.now - char.last_xp_spend)
      return nil if time_to_go < 0
      return t('fs3xp.must_wait_to_spend', :time => TimeFormatter.format(time_to_go.to_i))
    end
  end
end
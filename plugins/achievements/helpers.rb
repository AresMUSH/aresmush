module AresMUSH
  module Achievements
    def self.can_manage_achievements?(actor)
      return false if !actor
      return actor.has_permission?("manage_achievements")
    end
    
    def self.has_achievement?(char, name)
      char.achievements.any? { |a| a.name == name }
    end
    
    def self.custom_achievement_data(achievement)
      data = Global.read_config("achievements", "custom_achievements")
      data.select { |k, v| k.downcase == achievement.downcase }.values.first
    end
  end  
end
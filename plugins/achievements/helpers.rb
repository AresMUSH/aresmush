module AresMUSH
  module Achievements
    def self.can_manage_achievements?(actor)
      actor && actor.has_permission?("manage_achievements")
    end
    
    def self.all_achievements
      Global.plugin_manager.achievements
    end
    
    def self.has_achievement?(char, name, count = 0)
      achievement = char.achievements.select { |a| a.name == name }.first
      return false if !achievement
      if (count > 0)
        return achievement.count >= count
      end
      return true
    end
    
    def self.achievement_data(achievement)
      data = Achievements.all_achievements
      data.select { |k, v| k.downcase == achievement.downcase }.values.first
    end
    
    def self.format_achievement_name(name)
      name ? name.downcase.split.join("_") : nil
    end
    
    def self.achievement_levels(achievement, defaults = [])
      data = self.achievement_data(achievement) || {}
      data["levels"] || defaults
    end
    
    # Formats the message, accounting for count, based on input from the values in Achievements.achievements_list(char)
    def self.achievement_message(data)
      message = data[:message]
      count = data[:count]
      if (count > 1)
        return "#{message} (#{count})"
      else
        return message
      end
    end
  end  
end
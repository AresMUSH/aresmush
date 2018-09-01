module AresMUSH
  module Achievements
    def self.is_enabled?
      !Global.plugin_manager.is_disabled?("achievements")
    end
    
    def self.has_achievement?(char, name)
      char.achievements.any? { |a| a.name == name }
    end
    
    def self.achievement_display(name, count)
      display = name
      if (count > 1)
        display << " (#{count})"
      end
      display
    end
  end  
end
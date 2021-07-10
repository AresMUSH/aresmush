module AresMUSH
  module Achievements
    
    def self.is_enabled?
      !Global.plugin_manager.is_disabled?("achievements")
    end
    
    def self.award_achievement(char, name, count = 0)
      return nil if !Achievements.is_enabled?
      return nil if char.is_admin? || char.is_npc? || char.is_guest?
      
      achievement_details = Achievements.achievement_data(name)          
      if (!achievement_details)
        Global.logger.warn "Achievement not found: #{name}"
        return t('achievements.invalid_achievement')
      end
      
      type = achievement_details['type']
      message = achievement_details['message']
      
      if (!type || !message)
        raise "Invalid achievement details for #{name}.  Missing type or message."
      end
      
      if (!Achievements.has_achievement?(char, name, count))
        Global.logger.info "Awarding #{name} (#{count}) achievement to #{char.name}."

        message = message % { count: count }
        achievement = char.achievements.select { |a| a.name == name }.first
        
        if (achievement)
          achievement.update(count: count, message: message)
        else
          achievement = Achievement.create(character: char, type: type, name: name, message: message, count: count)
        end

        Login.notify(char, :achievement, t('achievements.achievement_noification_message', :message => message), achievement.id)
        
        notification = t('achievements.achievement_earned', :name => char.name, :message => message)
        Channels.announce_notification(notification)
      end
      return nil
    end
    
    def self.achievements_list(char)
      data = {}

      char.achievements.each do |a|
        data[a.name] = { count: 1, type: a.type, message: a.message }
      end

      if (char.is_playerbit?)
        alts = AresCentral.alts(char)
        alts = alts.concat Character.all.select { |c| c.content_tags.include?("player:#{char.name}".downcase)}
        
        alts.each do |c|
          c.achievements.each do |a|
            if (data[a.name])
              count = data[a.name][:count]
              data[a.name] = { count: count + 1, type: a.type, message: a.message }
            else
              data[a.name] = { count: 1, type: a.type, message: a.message }
            end
          end
        end
      end
      data.sort_by { |name, data| [ data[:type], data[:message] ] }
    end
   
    def self.build_achievements(player)
      return {} if !Achievements.is_enabled? 
      
      icon_types = Global.read_config('achievements', 'types')
      
      Achievements.achievements_list(player).map { |name, data| {
        name: name,
        type: data[:type],
        message: data[:message],
        count: (data[:count] || 0) > 1 ? data[:count] : nil,
        type_icon: icon_types["#{data[:type]}"] || "fa-question"
      }}
    end
    
    def self.build_web_profile_data(char, viewer)
      {
        achievements: Achievements.is_enabled? ? Achievements.build_achievements(char) : nil
      }
    end
  end
end
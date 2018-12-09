module AresMUSH
  module Achievements
    
    def self.is_enabled?
      !Global.plugin_manager.is_disabled?("achievements")
    end
    
    def self.award_achievement(char, name, type = nil, message = nil)
      return if char.is_admin? || char.is_npc? || char.is_guest?
      
      achievement_data = Achievements.custom_achievement_data(name)
      if (achievement_data)
        if (!type)
          type = achievement_data['type']
        end
        if (!message)
          message = achievement_data['message']
        end
      end
      
      if (!type || !message)
        raise "Invalid achievement details.  Missing name or message."
      end
      
      if (Achievements.is_enabled? && !Achievements.has_achievement?(char, name))
        Achievement.create(character: char, type: type, name: name, message: message)
        notification = t('achievements.achievement_earned', :name => char.name, :message => message)
        Global.notifier.notify_ooc(:achievement, notification) do |char|
          true
        end
      end
    end
    
    def self.achievements_list(char)
      data = {}

      char.achievements.each do |a|
        data[a.name] = { count: 1, type: a.type, message: a.message }
      end

      if (char.is_playerbit?)
        alts = AresCentral.alts_of(char)
        alts = alts.concat Character.all.select { |c| c.profile_tags.include?("player:#{char.name}".downcase)}
        
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
      data.sort_by { |name, data| data[:type] }
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
  end
end
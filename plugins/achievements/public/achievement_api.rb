module AresMUSH
  module Achievements
    
    def self.achievement_types
      [ :community, :story, :portal, :fs3 ]
    end
    
    def self.award_achievement(char, name, type, message)
      return if char.is_admin? || char.is_npc? || char.is_guest?
      
      if (Achievements.is_enabled? && !Achievements.has_achievement?(char, name))
        Achievement.create(character: char, type: type, name: name, message: message)
        Global.client_monitor.emit_all_ooc t('achievements.achievement_earned', :name => char.name, :message => message) do
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
        AresCentral.alts_of(char).each do |c|
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
    
  end
end
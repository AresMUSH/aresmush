module AresMUSH
  module Achievements
    class AchievementsAllCmd
      include CommandHandler
      
      def handle
        list = Achievements.all_achievements.sort_by { |k, v| [v['type'], v['message']] }
           .map { |k, v| format_achievement(k, v)}
        template = BorderedListTemplate.new list, t('achievements.all_achievements_title')
        client.emit template.render
      end
      
      def format_achievement(name, data)
        message = (data['message'] || "---") % { count: 'XXX' }
        type = (data['type'] || "---").titlecase
        key = Achievements.can_manage_achievements?(enactor) ? "%xh%xx(#{name})%xn" : ""
        
        "#{message.ljust(50)}#{type.ljust(10)}#{key}"
      end
    end
  end
end
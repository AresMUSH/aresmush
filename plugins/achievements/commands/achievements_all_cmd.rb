module AresMUSH
  module Achievements
    class AchievementsAllCmd
      include CommandHandler
      
      def handle
        template = AllAchievementsTemplate.new(enactor)
        client.emit template.render
      end
    end
  end
end
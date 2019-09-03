module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler

      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end

      def handle
        Character.all.each do |c|
          c.achievements.each do |achievement|
            # if (achievement.name =~ /has_died_/)
            #   count = achievement.name.split('_').last.to_i
            #   Achievements.award_achievement(c, 'has_died', count)
            #   achievement.delete
            # end

            if (achievement.name =~ /gave_comps_/)
              count = achievement.name.split('_').last.to_i
              Achievements.award_achievement(c, 'gave_comps', count)
              achievement.delete
            end
          end
      end

    end
  end
end

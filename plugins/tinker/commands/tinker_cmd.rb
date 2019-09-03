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
            if (achievement.name =~ /fs3_joined_combat_/)
              count = achievement.name.split('_').last.to_i
              Achievements.award_achievement(c, 'fs3_joined_combat', count)
              achievement.delete
            end

            if (achievement.name =~ /word_count_/)
              count = achievement.name.split('_').last.to_i
              Achievements.award_achievement(c, 'word_count', count)
              achievement.delete
            end

            if (achievement.name =~ /scene_participant_/)
              count = achievement.name.split('_').last.to_i
              if (count > 0)
                Achievements.award_achievement(c, 'scene_participant', count)
                achievement.delete
              end
            end

            if (achievement.name =~ /cookie_received_/)
              count = achievement.name.split('_').last.to_i
              Achievements.award_achievement(c, 'cookie_received', count)
              achievement.delete
            end
          end
        end



      end

    end
  end
end

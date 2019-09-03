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

            if (achievement.name =~ /made_potions_/)
              count = achievement.name.split('_').last.to_i
              Achievements.award_achievement(c, 'potions_made', count)
              achievement.delete
            end

            if (achievement.name =~ /used_potions_/)
              count = achievement.name.split('_').last.to_i
              if (count > 0)
                Achievements.award_achievement(c, 'potions_used', count)
                achievement.delete
              end
            end

            if (achievement.name =~ /learned_spells_/)
              count = achievement.name.split('_').last.to_i
              Achievements.award_achievement(c, 'spells_learned', count)
              achievement.delete
            end

            if (achievement.name =~ /cast_spells_/)
              count = achievement.name.split('_').last.to_i
              Achievements.award_achievement(c, 'spells_cast', count)
              achievement.delete
            end
          end
        end



      end

    end
  end
end

module AresMUSH
  module Achievements
    class AchievementRemoveCmd
      include CommandHandler
      
      attr_accessor :name, :achievement_name
      
      def parse_args
         args = cmd.parse_args(ArgParser.arg1_equals_arg2)
         self.name = titlecase_arg(args.arg1)
         self.achievement_name = downcase_arg(args.arg2)
      end
      
      def required_args
        [ self.name, self.achievement_name ]
      end
      
      def check_permissions
        Achievements.can_manage_achievements?(enactor) ? nil : t('dispatcher.not_allowed')
      end
      
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          achievement = model.achievements.select { |a| a.name == self.achievement_name }.first
          
          if (!achievement)
            client.emit_failure t('achievements.doesnt_have_achievement', :name => self.name)
            return
          end
          
          achievement.delete
          client.emit_success t('achievements.achievement_removed')
        end
      end
    end
  end
end
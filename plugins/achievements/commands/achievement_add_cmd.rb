module AresMUSH
  module Achievements
    class AchievementAddCmd
      include CommandHandler
      
      attr_accessor :name, :achievement_name
      
      def parse_args
         args = cmd.parse_args(ArgParser.arg1_equals_arg2)
         self.name = titlecase_arg(args.arg1)
         self.achievement_name = downcase_arg(args.arg2)
      end
      
      def check_permissions
        Achievements.can_manage_achievements?(enactor) ? nil : t('dispatcher.not_allowed')
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          if (Achievements.has_achievement?(model, self.achievement_name))
            client.emit_failure t('achievements.already_has_achievement', :name => self.name)
            return
          end
          
          config = Global.read_config("achievements", "custom_achievements") || {}
          achievement_details = config.select { |k, v| k.downcase == self.achievement_name }.values.first
          
          if (!achievement_details)
            client.emit_failure t('achievements.invalid_achievement')
            return
          end
          
          Achievements.award_achievement(model, self.achievement_name, achievement_details['type'], achievement_details['message'])
          client.emit_success t('achievements.achievement_added')
        end
      end
    end
  end
end
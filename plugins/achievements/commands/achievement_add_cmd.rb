module AresMUSH
  module Achievements
    class AchievementAddCmd
      include CommandHandler
      
      attr_accessor :names, :achievement_name
      
      def parse_args
         args = cmd.parse_args(ArgParser.arg1_equals_arg2)
         self.names = list_arg(args.arg1)
         self.achievement_name = Achievements.format_achievement_name(args.arg2)
      end
      
      def required_args
        [ self.names, self.achievement_name ]
      end
      
      def check_permissions
        Achievements.can_manage_achievements?(enactor) ? nil : t('dispatcher.not_allowed')
      end
      
      def handle
        self.names.each do |name|
          ClassTargetFinder.with_a_character(name, client, enactor) do |model|
            if (Achievements.has_achievement?(model, self.achievement_name))
              client.emit_failure t('achievements.already_has_achievement', :name => name)
              return
            end
          
            error = Achievements.award_achievement(model, self.achievement_name)
            if (error)
              client.emit_failure error
            else
              client.emit_success t('achievements.achievement_added')
            end
          end
        end
      end
    end
  end
end
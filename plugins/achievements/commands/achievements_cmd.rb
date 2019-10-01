module AresMUSH
  module Achievements
    class AchievementsCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = cmd.args ? titlecase_arg(cmd.args) : enactor_name
      end
      
      def handle
        Login.mark_notices_read(enactor, :achievement)
        
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          template = AchievementsTemplate.new Achievements.achievements_list(model), model, enactor
          client.emit template.render
        end
      end
    end
  end
end
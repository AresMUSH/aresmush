module AresMUSH

  module FS3Skills
    class SetGoalCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :goal

      def initialize
        self.required_args = ['goal']
        self.help_topic = 'abilities'
        super
      end
      
      def crack!
        self.goal = cmd.args
      end
      
      def handle
        client.char.fs3_goals = self.goal
        client.char.save
        
        client.emit_success t('fs3skills.goals_set')
      end
    end
  end
end

module AresMUSH

  module FS3Skills
    class SetGoalCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :goal

      def initialize(client, cmd, enactor)
        self.required_args = ['goal']
        self.help_topic = 'abilities'
        super
      end
      
      def crack!
        self.goal = cmd.args
      end
      
      def handle
        enactor.fs3_goals = self.goal
        enactor.save
        
        client.emit_success t('fs3skills.goals_set')
      end
    end
  end
end

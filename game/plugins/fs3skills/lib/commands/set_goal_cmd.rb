module AresMUSH

  module FS3Skills
    class SetGoalCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :goal
      
      def crack!
        self.goal = cmd.args
      end

      def required_args
        {
          args: [ self.goal ],
          help: 'abilities'
        }
      end
      
      def handle
        enactor.fs3_goals = self.goal
        enactor.save
        
        client.emit_success t('fs3skills.goals_set')
      end
    end
  end
end

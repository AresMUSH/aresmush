module AresMUSH

  module FS3Skills
    class SetGoalCmd
      include Plugin
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :goal

      def initialize
        self.required_args = ['goal']
        self.help_topic = 'abilities'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("goal")
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

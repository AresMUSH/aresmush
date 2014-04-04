module AresMUSH
  module Utils
    class ExamineCmd
      include Plugin
      include PluginWithoutSwitches
      include PluginRequiresArgs
      
      attr_accessor :target
      
      def initialize
        self.required_args = ['target']
        self.help_topic = 'examine'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("examine")
      end
      
      def crack!
        self.target = trim_input(cmd.args)
      end
        
      def handle
        find_result = VisibleTargetFinder.find(self.target, client)
        if (find_result.found?)
          client.emit "%l1%r#{find_result.target.to_json}%r%l1"
          return
        end
        
        find_result = AnyTargetFinder.find(self.target, client)
        if (!find_result.found?)
          client.emit_failure(find_result.error)
          return
        end
        client.emit "%l1%r#{find_result.target.to_json}%r%l1"
      end
    end
  end
end

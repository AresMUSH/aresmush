module AresMUSH
  module Utils
    class ExamineCmd
      include AresMUSH::Plugin
      
      attr_accessor :target
      
      # Validators
      no_switches
      argument_must_be_present "target", "examine"
      
      def want_command?(client, cmd)
        cmd.root_is?("examine")
      end
      
      def crack!
        self.target = trim_input(cmd.args)
      end
        
      def handle
        find_result = VisibleTargetFinder.find(self.target, client)
        if (!find_result.found?)
          client.emit_failure(find_result.error)
          return
        end
        client.emit "%l1%r#{find_result.target.inspect}%r%l1"
      end
    end
  end
end

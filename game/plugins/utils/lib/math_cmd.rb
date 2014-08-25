module AresMUSH
  module Utils
    class MathCmd
      include Plugin
      include PluginWithoutSwitches
      include PluginRequiresLogin
      include PluginRequiresArgs
      
      attr_accessor :expression
      
      def initialize
        self.required_args = ['expression']
        self.help_topic = 'math'
        super
      end
      
      def want_command?(client, cmd)
        cmd.root_is?("math")
      end
      
      def crack!
        self.expression = cmd.args
      end

      def handle
        result = Dentaku(self.expression)
        client.emit_ooc "#{self.expression} = #{result}"
      end
    end
  end
end

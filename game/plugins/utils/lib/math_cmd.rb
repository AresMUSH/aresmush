module AresMUSH
  module Utils
    class MathCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :expression
      
      def initialize(client, cmd, enactor)
        self.required_args = ['expression']
        self.help_topic = 'math'
        super
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

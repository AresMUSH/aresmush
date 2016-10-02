module AresMUSH
  module Utils
    class MathCmd
      include CommandHandler
      include CommandWithoutSwitches
      include CommandRequiresLogin
      include CommandRequiresArgs
      
      attr_accessor :expression
      
      def crack!
        self.expression = cmd.args
      end
      
      def required_args
        {
          args: [ self.expression ],
          help: 'math'
        }
      end
      
      def handle
        result = Dentaku(self.expression)
        client.emit_ooc "#{self.expression} = #{result}"
      end
    end
  end
end

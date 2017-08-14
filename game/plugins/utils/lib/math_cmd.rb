module AresMUSH
  module Utils
    class MathCmd
      include CommandHandler
      
      attr_accessor :expression
      
      def parse_args
        self.expression = cmd.args
      end
      
      def required_args
        [ self.expression ]
      end
      
      def handle
        result = Dentaku(self.expression)
        client.emit_ooc "#{self.expression} = #{result}"
      end
    end
  end
end

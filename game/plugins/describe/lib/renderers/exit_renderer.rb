module AresMUSH
  module Describe
    class ExitRenderer
      def initialize(template)
        @template = template
      end
      
      def render(exit)
        data = ExitData.new(exit)
        @template.render(data)
      end
    end
  end
end
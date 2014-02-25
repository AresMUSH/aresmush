module AresMUSH
  module Describe
    class CharRenderer
      def initialize(template)
        @template = template
      end
      
      def render(char)
        data = CharData.new(char)
        @template.render(data)
      end
    end
  end
end
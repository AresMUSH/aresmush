module AresMUSH
  module Website
    class TagMatchHelper
      attr_accessor :or_tags, :required_tags, :exclude_tags
      
      def initialize(input)
        tags = (input || "").split(" ").map { |t| t.downcase }
        
        @or_tags = tags.select { |tag| !tag.start_with?("-") && !tag.start_with?("+")}
         
        @required_tags = tags.select { |tag| tag.start_with?("+") }
        .map { |tag| tag.after("+") }
         
        @exclude_tags = tags.select { |tag| tag.start_with?("-") }
        .map { |tag| tag.after("-") }
      end
      
    end
  end
end
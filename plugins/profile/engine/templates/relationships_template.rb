module AresMUSH
  module Profile
    class RelationshipsTemplate < ErbTemplateRenderer
      
      attr_accessor :char
      
      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/relationships.erb"
      end
      
      def categories
        Profile.relationships_by_category(@char)
      end
    end
  end
end
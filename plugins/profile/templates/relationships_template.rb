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
      
      def sorted_relationships(relations)
        relations.sort_by { |name, data| [ data['order'] || 99, name ] }
      end
    end
  end
end
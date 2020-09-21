module AresMUSH    
  module Swade
    class IconicfTemplate < ErbTemplateRenderer

      attr_accessor :types
      
      def initialize(types)
        self.types = types
        super File.dirname(__FILE__) + "/iconicf.erb"
      end
      
      def stats(type)
        (type['stats'] || {}).map { |name, rating| "#{name}:#{rating}" }.join(", ")
      end
      

    end
  end
end
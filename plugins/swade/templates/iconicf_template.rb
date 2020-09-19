module AresMUSH    
  module Swade
    class iconicfTemplate < ErbTemplateRenderer

      attr_accessor :types
      
      def initialize(types)
        self.types = types
        super File.dirname(__FILE__) + "/iconicf.erb"
      end
      
      def attributes(type)
        (type['attributes'] || {}).map { |name, rating| "#{name}:#{rating}" }.join(", ")
      end
      

    end
  end
end
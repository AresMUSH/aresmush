module AresMUSH    
  module Swade
    class HinderancesTemplate < ErbTemplateRenderer

      attr_accessor :types
      
      def initialize(types)
        self.types = types
        super File.dirname(__FILE__) + "/hinderances.erb"
      end
      
      def hinderances(type)
        (type['hinderances'] || {}).map { |name, hind_points, description| "#{name}:#{hind_points} #{description}" }
      end
      

    end
  end
end
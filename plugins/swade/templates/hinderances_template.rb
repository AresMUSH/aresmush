module AresMUSH    
  module Swade
    class HinderancesTemplate < ErbTemplateRenderer

      attr_accessor :types
      
      def initialize(types)
        self.types = types
        super File.dirname(__FILE__) + "/hinderances.erb"
      end
      
	  def description(type)
		type['description']
      end 

    end
  end
end
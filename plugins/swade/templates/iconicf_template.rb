module AresMUSH    
  module Swrifts
    class IconicfTemplate < ErbTemplateRenderer

      attr_accessor :types
      
      def initialize(types)
        self.types = types
        super File.dirname(__FILE__) + "/iconicf.erb"
      end
      
	  def description(type)
		type['description']
      end 

    end
  end
end
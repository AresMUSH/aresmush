module AresMUSH    
  module Swade
    class StatsTemplate < ErbTemplateRenderer

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
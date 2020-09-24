module AresMUSH    
  module Swrifts
    class StatsTemplate < ErbTemplateRenderer

      attr_accessor :types
      
      def initialize(types)
        self.types = types
        super File.dirname(__FILE__) + "/stats.erb"
      end
      
	  def description(type)
		type['description']
      end 

    end
  end
end
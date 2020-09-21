module AresMUSH    
  module Swade
    class IconicfTemplate < ErbTemplateRenderer

      attr_accessor :types
      
      def initialize(types)
        self.types = types
        super File.dirname(__FILE__) + "/iconicf.erb"
      end
      
      def iconcfs(type)
        (type['iconicf'] || {}).map { |name, description| "#{name}:#{description}" }.join(", ")
      end
      

    end
  end
end
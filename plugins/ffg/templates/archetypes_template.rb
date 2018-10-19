module AresMUSH    
  module Ffg
    class ArchetypesTemplate < ErbTemplateRenderer

      attr_accessor :types
      
      def initialize(types)
        self.types = types
        super File.dirname(__FILE__) + "/archetypes.erb"
      end
      
      def skills(type)
        (type['skills'] || []).join(", ")
      end

      def characteristics(type)
        (type['characteristics'] || {}).map { |name, rating| "#{name}:#{rating}" }.join(", ")
      end
      
      def talents(type)
        (type['talents'] || []).join(", ")
      end
      
      def universal_specs
        Ffg.universal_specializations
      end
    end
  end
end
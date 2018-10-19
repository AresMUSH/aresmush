module AresMUSH    
  module Ffg
    class CareersTemplate < ErbTemplateRenderer

      attr_accessor :careers
      
      def initialize(careers)
        self.careers = careers
        super File.dirname(__FILE__) + "/careers.erb"
      end
      
      def skills(career)
        (career['career_skills'] || []).join(", ")
      end
      
      def specs(career)
        Ffg.specializations_for_career(career['name'])
      end
      
      def universal_specs
        Ffg.universal_specializations
      end
    end
  end
end
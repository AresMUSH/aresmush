module AresMUSH
  module Demographics
    class SkillsCensusTemplate < ErbTemplateRenderer
            
      attr_accessor :skills, :type
      
      def initialize(type)
        self.type = type
        self.skills = FS3Skills::Api.skills_census(type)
        super File.dirname(__FILE__) + "/skills_census.erb"
      end
    end
  end
end

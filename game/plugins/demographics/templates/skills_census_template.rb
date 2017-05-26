module AresMUSH
  module Demographics
    class SkillsCensusTemplate < ErbTemplateRenderer
            
      attr_accessor :skills
      
      def initialize
        self.skills = FS3Skills::Api.skills_census
        super File.dirname(__FILE__) + "/skills_census.erb"
      end
    end
  end
end

module AresMUSH
  module FS3Skills
    # Template for an exit.
    class XpTemplate < ErbTemplateRenderer
      include TemplateFormatters
            
      def initialize
        super File.dirname(__FILE__) + "/xp.erb"        
      end
      
      def lang_cost
        Global.read_config("fs3skills", "lang_cost")
      end
      
      def ability_cost
        Global.read_config("fs3skills", "skill_costs")
      end
      
      def hoard_limit
        Global.read_config("fs3skills", "max_xp_hoard")
      end
      
      def days_between_raises
        Global.read_config("fs3skills", "days_between_xp_raises")
      end            
    end
  end
end

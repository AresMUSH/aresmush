module AresMUSH
  module FS3XP
    # Template for an exit.
    class XpTemplate < ErbTemplateRenderer
      include TemplateFormatters
            
      def initialize
        super File.dirname(__FILE__) + "/xp.erb"        
      end
      
      def lang_cost
        Global.read_config("fs3xp", "lang_cost")
      end
      
      def ability_cost
        Global.read_config("fs3xp", "skill_costs")
      end
      
      def hoard_limit
        Global.read_config("fs3xp", "max_xp_hoard")
      end
      
      def days_between_raises
        Global.read_config("fs3xp", "days_between_xp_raises")
      end            
    end
  end
end

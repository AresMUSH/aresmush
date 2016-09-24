module AresMUSH
  module FS3Combat
    class CombatSummaryTemplate < ErbTemplateRenderer

      include TemplateFormatters

      attr_accessor :combat
      
      def initialize(combat)
        @combat = combat
        super File.dirname(__FILE__) + "/summary.erb"
      end
      
      def slack(c)
        acted = c.action.nil? ? '%xh%xr**%xn' : '%xg++%xn'
        posed = c.is_npc? ? '%xg--%xn' : (c.posed ? '%xg++%xn' : '%xh%xr**%xn')
        "#{acted} / #{posed}   "
      end
      
      def skill(c)
        if (c.is_npc?)
          rating = c.npc_skill
        else
          weapon_skill = FS3Combat.weapon_stat(c.weapon, "skill")
          rating = FS3Skills::Api.ability_rating(c.character, weapon_skill)          
        end
        rating
      end
      
      def weapon(c)
        weapon = "#{c.weapon}"
        if (c.weapon_specials)
          weapon << " (#{c.weapon_specials.join(",")})"
        end
        weapon
      end
    end
  end
end
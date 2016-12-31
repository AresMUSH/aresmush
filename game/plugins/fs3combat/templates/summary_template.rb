module AresMUSH
  module FS3Combat
    class CombatSummaryTemplate < ErbTemplateRenderer


      attr_accessor :combat
      
      def initialize(combat)
        @combat = combat
        super File.dirname(__FILE__) + "/summary.erb"
      end
      
      def slack(c)
        acted = !c.action ? '%xh%xr**%xn' : '%xg++%xn'
        posed = c.is_npc? ? '%xg--%xn' : (c.posed ? '%xg++%xn' : '%xh%xr**%xn')
        "#{acted} / #{posed}   "
      end
      
      def skill(c)
        weapon_skill = FS3Combat.weapon_stat(c.weapon, "skill")
        if (c.is_npc?)
          rating = c.npc.ability_rating(weapon_skill)
        else
          rating = FS3Skills::Api.ability_rating(c.character, weapon_skill)          
        end
        rating
      end
    end
  end
end
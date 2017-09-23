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
        
        if (c.is_npc?)
          posed = '%xg--%xn'
        elsif (c.idle)
          posed = '%xx%xhxx%xn'
        elsif (c.posed)
          posed = '%xg++%xn'
        else
          last_posed = c.character.last_posed || "**"          
          posed = "%xh%xr#{last_posed}%xn"
        end
        "#{acted} / #{left(posed, 5)}   "
      end
      
      def skill(c)
        weapon_skill = FS3Combat.weapon_stat(c.weapon, "skill")
        if (c.is_npc?)
          rating = c.npc.ability_rating(weapon_skill)
        else
          rating = FS3Skills.dice_rolled(c.character, weapon_skill)          
        end
        rating
      end
      
      
      def vehicles
        combat.vehicles.sort_by(:name, :order => "ALPHA" ).map { |v| v.name }.join(" ")
      end
      
    end
  end
end
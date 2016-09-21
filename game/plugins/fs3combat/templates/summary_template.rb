module AresMUSH
  module FS3Combat
    class CombatSummaryTemplate < AsyncTemplateRenderer

      include TemplateFormatters

      def initialize(combat, client)
        @combat = combat
        super client
      end
      
      def build
        text = "%l1%R"
        text << "%xh#{t('fs3combat.summary_title')}%xn"
        @combat.active_combatants.each do |c|
          text << "%R#{show_name(c)} #{show_slack(c)} #{show_skill(c)} #{show_weapon(c)}  #{show_armor(c)}  #{show_stance(c)}"
        end
        text << "%R%l1"
      end
      
      def show_name(c)
        left(c.name, 15)
      end
      
      def show_slack(c)
        acted = c.action.nil? ? '%xh%xr**%xn' : '++'
        posed = c.is_npc? ? '--' : (c.posed ? '++' : '%xh%xr**%xn')
        "#{acted} / #{posed}   "
      end
      
      def show_skill(c)
        if (c.is_npc?)
          rating = c.npc_skill
        else
          weapon_skill = FS3Combat.weapon_stat(c.weapon, "skill")
          rating = FS3Skills::Api.ability_rating(c.character, weapon_skill)          
        end
        left("#{rating}", 5)
      end
      
      def show_weapon(c)
        weapon = "#{c.weapon}"
        if (c.weapon_specials)
          weapon << " (#{c.weapon_specials.join(",")})"
        end
        left(weapon, 15)
      end
      
      def show_armor(c)
        left(c.armor, 15)
      end
      
      def show_stance(c)
        left(c.stance, 15)
      end
    end
  end
end
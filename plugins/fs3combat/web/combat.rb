module AresMUSH
  class WebApp
    
    helpers do
      def combatants_by_team(combat)
        combat.active_combatants.sort_by{|c| c.team}.group_by {|c| c.team}
      end
      
      def display_damage_severity(severity)
        format_output_for_html FS3Combat.display_severity(severity)
      end
      
    end
    
    get '/combat/?' do
      @combats = Combat.all
      erb :"combat/combat_index"
    end
    
  end
end

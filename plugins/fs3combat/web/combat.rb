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
    
    get '/kills/?' do
      @scoreboard = VictoryKill.all.select { |k| !k.character.idle_state }.group_by { |k| k.character }.sort_by { |char, victories| victories.count }.reverse
      @scenes = VictoryKill.all.group_by { |k| k.scene }.sort_by { |scene, victories| scene.icdate }.reverse
      erb :"combat/kills"
    end
  end
end

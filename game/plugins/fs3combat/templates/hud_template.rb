module AresMUSH
  module FS3Combat
    class CombatHudTemplate < ErbTemplateRenderer

      include TemplateFormatters

      attr_accessor :combat
      
      def initialize(combat)
        @combat = combat
        super File.dirname(__FILE__) + "/hud.erb"
      end
           
      def organizer
        t('fs3combat.combat_hud_organizer', :org => @combat.organizer.name)
      end
      
      def title
        t('fs3combat.combat_hud_header', :num => @combat.id)
      end
       
      def teams
        @combat.active_combatants.sort_by{|c| c.team}.group_by {|c| c.team}
      end
      
      
      def format_action(c)
        action = c.action ? c.action.print_action_short : "----"
        "#{action} #{format_stance(c)}"
      end
      
      def format_stance(c)
        case c.stance
        when "Normal"
          text = ""
        when "Aggressive"
          text = "(AGG)"
        when "Defensive"
          text = "(DEF)"
        when "Evade"
          text = "(EVA)"
        when "Cover"
          text = "(COV)"
        when "Hidden"
          text = "(HID)"
        end
        text
      end
      
      def pilot(v)
        v.pilot ? v.pilot.name : t('fs3combat.no_pilot')
      end
      
      def passengers(v)
        v.passengers.map { |p| p.name }.join(",")
      end
      
      def vehicles
        combat.vehicles.sort_by(:name, :order => "ALPHA" ).map { |v| v.name }.join(" ")
      end
      
      def non_combatants
        @combat.non_combatants.map { |c| c.name}.join(", ")
      end
      
      def format_vehicle(c)
        if (c.piloting)
          text = t('fs3combat.piloting_hud', :vehicle => c.piloting.name)
        elsif (c.riding_in)
          text = t('fs3combat.passenger_hud', :vehicle => c.riding_in.name)
        else
         text =  ""
        end
        text
      end
      
      def format_damage(c)
        FS3Combat.print_damage(c.total_damage_mod)
      end
      
      def format_weapon(c)
        weapon = "#{c.weapon}"
        
        if (c.max_ammo > 0)
          notes = " (#{c.ammo})"
        else
          notes = ""
        end
        
        "#{weapon}#{notes}"
      end
    end
  end
end
module AresMUSH
  module FS3Combat
    class CombatHudTemplate < AsyncTemplateRenderer

      include TemplateFormatters

      def initialize(combat, client)
        @combat = combat
        super client
      end
      
      def build
        text = format_header
        teams = @combat.active_combatants.group_by {|c| c.team}
        teams.sort.each do |team, members|
          text << "%R%xg#{t('fs3combat.team_header', :team => team)}%xn"
          text << members.map { |c| format_combatant(c) }.join
        end
        text << format_vehicles
        text << format_non_combatants
        text << "%R%l1"
      end
      
      def format_header
        title = t('fs3combat.combat_hud_header', :num => @combat.num)
        org = t('fs3combat.combat_hud_organizer', :org => @combat.organizer.name)
        text = "%l1%R%xh#{left(title, 39)}#{right(org, 39)}%xn"
        text << "%r%l2"
        if (!@combat.is_real)
          msg = t('fs3combat.combat_mock_notice')
          text << "%r%xg#{center(msg, 78)}%xn"
          text << "%r%l2"
        end
        text << "%R#{t('fs3combat.hud_subtitle')}"
        text
      end
      
      def format_combatant(c)
        "%R#{left(c.name, 18)} #{format_damage(c)}   #{format_weapon(c)} #{format_action(c)}"
      end
      
      def format_action(c)
        action = c.action ? c.action.print_action_short : "----"
        action = "#{action} #{format_stance(c)}"
        left(action, 25)
      end
      
      def format_stance(c)
        case c.stance
        when "Normal"
          text = ""
        when "Banzai"
          text = "(BNZ)"
        when "Cautious"
          text = "(CAU)"
        when "Evade"
          text = "(EVA)"
        end
        text
      end
      
      def format_vehicles
        text = "%R%l2%R"
        text << "%xh#{t('fs3combat.vehicles_hud_title')}%xn"
        @combat.vehicles.each do |v|
          pilot = v.pilot ? v.pilot.name : t('fs3combat.no_pilot')
          passengers = v.passengers.map { |p| p.name }.join(",")
          text << "%R"
          text << left(v.name,20)
          text << left(pilot, 17)
          text << passengers
        end
        
        text
      end
      
      def format_non_combatants
        text = "%R%l2%R"
        text << "%xh#{t('fs3combat.observers_title')}%xn%R"
        text << @combat.non_combatants.map { |c| c.name}.join(", ")
        text
      end
      
      def format_vehicle(c)
        if (c.piloting)
          text = t('fs3combat.piloting_hud', :vehicle => c.piloting.name)
        elsif (c.riding_in)
          text = t('fs3combat.passenger_hud', :vehicle => c.riding_in.name)
        else
         text =  ""
        end
        left(text, 20)
      end
      
      def format_damage(c)
        FS3Combat.print_damage(c.total_damage_mod)
      end
      
      
      def format_weapon(c)
        weapon = "#{c.weapon}"
        specials = c.weapon_specials ? c.weapon_specials.join(",") : ""
        
        if (c.ammo && !specials.blank?)
          notes = " (#{c.ammo}, #{specials})"
        elsif (c.ammo)
          notes = " (#{c.ammo})"
        elsif (!specials.blank?)
          notes = " (#{specials})"
        else
          notes = ""
        end
        
        left("#{weapon}#{notes}", 25)
      end
    end
  end
end
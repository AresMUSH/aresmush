module AresMUSH
  module FS3Combat
    class CombatHudCmd
      include Plugin
      include PluginRequiresLogin
      include TemplateFormatters
      
      def want_command?(client, cmd)
        cmd.root_is?("combat") && cmd.switch.nil?
      end
      
      def handle
        combat = FS3Combat.combat(client.char.name)
        if (!combat)
          client.emit_failure t('fs3combat.you_are_not_in_combat')
          return
        end
        
        text = format_header(combat)
        text << combat.active_combatants.map { |c| format_combatant(c) }.join
        text << format_non_combatants(combat)
        
        client.emit BorderedDisplay.text text
      end
    
      
      def format_header(combat)
        title = t('fs3combat.combat_hud_header', :num => combat.num)
        org = t('fs3combat.combat_hud_organizer', :org => combat.organizer.name)
        text = "%xh#{left(title, 39)}#{right(org, 39)}%xn"
        text << "%r%l2"
        if (!combat.is_real)
          msg = t('fs3combat.combat_mock_notice')
          text << "%r%xg#{center(msg, 78)}%xn"
          text << "%r%l2"
        end
        text
      end
      
      def format_combatant(c)
        "%R#{left(c.name, 15)} #{format_weapon(c)} #{c.combatant_type} #{format_damage(c)}"
      end
      
      def format_non_combatants(combat)
        text = "%R%l2%R"
        text << "%xh#{t('fs3combat.observers_title')}%xn%R"
        text << combat.non_combatants.map { |c| c.name}.join(", ")
        text
      end
      
      def format_damage(c)
        FS3Combat.print_damage(c.total_damage_mod)
      end
      
      
      def format_weapon(c)
        weapon = "#{c.weapon}"
        if (c.weapon_specials)
          weapon << " (#{c.weapon_specials.join(",")})"
        end
        weapon
      end

    end
  end
end
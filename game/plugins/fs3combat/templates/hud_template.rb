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
        text << @combat.active_combatants.map { |c| format_combatant(c) }.join
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
        text
      end
      
      def format_combatant(c)
        # TODO: Make this prettier
        action = c.action ? c.action.print_action_short : ""
        "%R#{left(c.name, 15)} #{c.stance} #{format_weapon(c)} #{c.combatant_type} #{format_damage(c)} #{action} #{c.ammo} #{c.ammo.nil?}"
      end
      
      def format_non_combatants
        text = "%R%l2%R"
        text << "%xh#{t('fs3combat.observers_title')}%xn%R"
        text << @combat.non_combatants.map { |c| c.name}.join(", ")
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
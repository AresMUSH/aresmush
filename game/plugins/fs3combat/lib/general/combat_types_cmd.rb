module AresMUSH
  module FS3Combat
    class CombatTypesCmd
      include Plugin
      include PluginRequiresLogin
      include TemplateFormatters
      
      def want_command?(client, cmd)
        cmd.root_is?("combat") && cmd.switch_is?("types")
      end
      
      def handle
        list = FS3Combat.combatant_types.sort.map { |k, v| type_display(k, v) }
        client.emit BorderedDisplay.subtitled_list list, t('fs3combat.combatant_types'), t('fs3combat.combatant_types_titlebar')
      end
        
      def type_display(name, info)
        text = left(name, 20)
        puts "#{name} #{info}"
        text << display_field(info, "weapon")
        text << display_field(info, "armor")
        text
      end

      def display_field(info, value_name)
        value = info[value_name] || "---"
        "#{left(value, 20)}"
      end
    end
  end
end
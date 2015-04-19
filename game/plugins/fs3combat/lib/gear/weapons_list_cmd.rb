module AresMUSH
  module FS3Combat
    class WeaponsListCmd
      include Plugin
      include PluginRequiresLogin
      include TemplateFormatters
      
      def want_command?(client, cmd)
        cmd.root_is?("weapons")
      end
      
      def handle
        list = FS3Combat.weapons.sort.map { |k, v| type_display(k, v) }
        client.emit BorderedDisplay.list list, t('fs3combat.weapons_title')
      end
        
      def type_display(name, info)
        text = left(name.titleize, 20)
        text << display_field(info, "description", 58)
        text
      end

      def display_field(info, value_name, width)
        value = info[value_name] || "---"
        "#{left(value, width)}"
      end
    end
  end
end
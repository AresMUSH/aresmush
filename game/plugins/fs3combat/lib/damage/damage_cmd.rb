module AresMUSH
  module FS3Combat
    class DamageCmd
      include Plugin
      include PluginRequiresLogin
      include TemplateFormatters
      
      attr_accessor :name

      def want_command?(client, cmd)
        cmd.root_is?("damage") && cmd.switch.nil?
      end
      
      def crack!
        self.name = cmd.args ? titleize_input(cmd.args) : client.char.name
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client) do |model|
          damage = model.damage.map { |d| damage_line(d) }
          client.emit BorderedDisplay.list damage, t('fs3combat.damage_title', :name => model.name)
        end
      end
      
      def damage_line(damage)
        line = left(OOCTime.local_short_timestr(client, damage.created_at), 12)
        line << left(FS3Combat.display_severity(damage.initial_severity),10)
        line << left(damage.description, 15)
        line << left("(#{FS3Combat.display_severity(damage.current_severity)})",10)
      end
    end
  end
end
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
          list = model.damage.map { |d| damage_line(d) }
          title = t('fs3combat.damage_title', :name => model.name)
          client.emit BorderedDisplay.subtitled_list list, title, t('fs3combat.damage_titlebar')
        end
      end
      
      def damage_line(damage)
        line = left(ICTime.ic_datestr(damage.ictime), 13)
        line << left(damage.description, 30)
        initial_sev = damage.initial_severity
        current_sev = FS3Combat.display_severity(damage.current_severity)
        
        line << left("#{current_sev} (#{initial_sev})", 22)
        line << center(damage.is_treatable? ? t('global.y') : t('global.n'), 10)
      end
    end
  end
end
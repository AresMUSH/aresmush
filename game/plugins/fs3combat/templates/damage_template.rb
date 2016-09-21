module AresMUSH
  module FS3Combat
    class DamageTemplate < AsyncTemplateRenderer

      include TemplateFormatters

      def initialize(char, client)
        @char = char
        super client
      end
      
      def build
        list = @char.damage.map { |d| damage_line(d) }
        title = t('fs3combat.damage_title', :name => @char.name)
        BorderedDisplay.subtitled_list list, title, t('fs3combat.damage_titlebar')
      end
      
      def damage_line(damage)
        line = left(ICTime::Api.ic_datestr(damage.ictime), 13)
        line << left(damage.description, 30)
        initial_sev = damage.initial_severity
        current_sev = FS3Combat.display_severity(damage.current_severity)
  
        line << left("#{current_sev} (#{initial_sev})", 22)
        line << center(damage.is_treatable? ? t('global.y') : t('global.n'), 10)
      end
    end
  end
end


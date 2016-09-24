module AresMUSH
  module FS3Combat
    class DamageTemplate < ErbTemplateRenderer

      include TemplateFormatters

      attr_accessor :damage, :char
      
      def initialize(char)
        @char = char
        @damage = char.damage
        super File.dirname(__FILE__) + "/damage.erb"
      end      
      
      def time(d)
        ICTime::Api.ic_datestr d.ictime
      end
      
      def severity(d)
        initial_sev = d.initial_severity
        current_sev = FS3Combat.display_severity(d.current_severity)
        "#{current_sev} (#{initial_sev})"
      end
      
      def treatable(d)
        d.is_treatable? ? t('global.y') : t('global.n')
      end      
    end
  end
end


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
      
      def severity(d)
        initial_sev = d.initial_severity
        current_sev = FS3Combat.display_severity(d.current_severity)
        "#{current_sev} (#{initial_sev[0..2]})"
      end
      
      def treatable(d)
        d.is_treatable? ? t('global.y') : t('global.n')
      end      
      
      def healed_by
        @char.healed_by.map { |h| }
      end
      
      def wound_mod
        FS3Combat.total_damage_mod(char)
      end
    end
  end
end


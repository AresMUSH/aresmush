module AresMUSH    
  module Ffg
    class TalentsTemplate < ErbTemplateRenderer

      attr_accessor :paginator
      
      def initialize(paginator)
        self.paginator = paginator
        super File.dirname(__FILE__) + "/talents.erb"
      end
      
      def talents_header
        Ffg.use_force? ? t('ffg.talents_headings_force') : t('ffg.talents_headings')
      end
        
        
      def name(talent)
        talent['name']
      end
      
      def tier(talent)
        talent['tier']
      end
      
      def ranked(talent)
        talent['ranked'] ? '*' : '-'
      end
      
      def force_power(talent)
        display = talent['force_power'] ? '*' : '-'
        Ffg.use_force? ? center(display, 7) : ''
      end
      
      def specializations(talent)
        specs = talent['specializations']
        specs ? specs.join(", ") : ""
      end
      
        
  
    end
  end
end
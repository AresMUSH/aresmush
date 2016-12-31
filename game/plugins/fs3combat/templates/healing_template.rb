module AresMUSH
  module FS3Combat
    class HealingTemplate < ErbTemplateRenderer


      attr_accessor :char
      
      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/healing.erb"
      end      
      
      def max_patients
        FS3Combat.max_patients(@char)
      end      
      
      def damage_mod(patient)
        FS3Combat.total_damage_mod(patient)
      end
    end
  end
end


module AresMUSH
  module FS3Combat
    class StancesTemplate < ErbTemplateRenderer

      attr_accessor :stances
      
      def initialize(stances)
        @stances = stances.sort
        super File.dirname(__FILE__) + "/stances.erb"
      end
      
      def attack_mod(stance)
        center( stance['attack_mod'], 5 )
      end

      def defense_mod(stance)
        center( stance['defense_mod'], 5 )
      end
      
      def name_and_abbr(name)
        abbr = name[0,3].downcase
        "#{name} (#{abbr})"
      end

    end
  end
end
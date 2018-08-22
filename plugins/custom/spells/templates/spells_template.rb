module AresMUSH
  module Custom
    class SpellsTemplate < ErbTemplateRenderer
      attr_accessor :char

      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/spells.erb"
      end


      def spells_learned
        @char.spells_learned.to_a
      end

      def spell_list
        self.spells_learned.sort_by { |s| s.level }
      end

      def major_school
        char.major_school
      end

      def minor_school
        char.minor_school
      end



    end
  end
end

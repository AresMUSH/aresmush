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

      

    end
  end
end

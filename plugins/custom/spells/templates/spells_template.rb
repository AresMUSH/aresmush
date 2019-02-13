module AresMUSH
  module Custom
    class SpellsTemplate < ErbTemplateRenderer
      attr_accessor :char

      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/spells.erb"
      end

      def spell_count
        Custom.count_spells_total(char)
      end

      def spells_learned
        @char.spells_learned.to_a
      end

      def spell_list
        self.spells_learned.sort_by { |s| s.level }
      end

      def major_school
        char.group("Major School")
      end

      def minor_school
        char.group("Minor School")
      end

      def item_spell
        Custom.item_spell(char)
      end

      def time_left_before_learn(spell)
        spell_learned = Custom.find_spell_learned(char, spell)
        (Custom.time_to_next_learn_spell(spell_learned) / 86400).ceil
      end


    end
  end
end

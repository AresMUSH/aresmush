module AresMUSH
  module Magic
    class SpellsTemplate < ErbTemplateRenderer
      attr_accessor :char

      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/spells.erb"
      end

      def spell_count
        Magic.count_spells_total(char)
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
        Magic.item_spell(char)
      end

      def time_left_before_learn(spell)
        spell_learned = Magic.find_spell_learned(char, spell)
        (Magic.time_to_next_learn_spell(spell_learned) / 86400).ceil
      end

      def xp
        char.xp
      end


    end
  end
end

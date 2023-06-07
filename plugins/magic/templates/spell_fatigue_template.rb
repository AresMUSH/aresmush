module AresMUSH
  module Magic
    class SpellFatigueTemplate < ErbTemplateRenderer
      attr_accessor :char

      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/spell_fatigue.erb"
      end

      def magic_energy
        ProgressBarFormatter.format(char.magic_energy, char.total_magic_energy)
      end

      def magic_energy_percent
        current = char.magic_energy
        total = char.total_magic_energy
        puts "Current: #{current} Total: #{total}"
        ((current.to_f/total.to_f)*100).round
      end

      def spell_fatigue_degree
        Magic.get_fatigue_level(char)[:degree]
      end

      def spell_fatigue_msg
        Magic.get_fatigue_level(char)[:msg]
      end

      def magic_energy_mod
        Magic.get_magic_energy_mod(char)
      end

      def magic_energy_attack_mod
        (magic_energy_mod.to_f / 2)
      end


    end
  end
end

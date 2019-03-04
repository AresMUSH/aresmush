module AresMUSH
  module Custom
    class SpellDetailTemplate < ErbTemplateRenderer


      attr_accessor :spell

      def initialize(spell)
        @spell = spell
        super File.dirname(__FILE__) + "/spell_detail.erb"
      end

      def name
        Global.read_config("spells", spell, "name")
      end

      def desc
        Global.read_config("spells", spell, "desc")
      end

      def available
        Global.read_config("spells", spell, "available")
      end

      def level
        Global.read_config("spells", spell, "level")
      end

      def school
        Global.read_config("spells", spell, "school")
      end

      def potion
        Global.read_config("spells", spell, "is_potion")
      end

      def duration
        Global.read_config("spells", spell, "duration")
      end

      def casting_time
        Global.read_config("spells", spell, "casting_time")
      end

      def range
        Global.read_config("spells", spell, "range")
      end

      def los
        Global.read_config("spells", spell, "line_of_sight")
      end

      def area
        Global.read_config("spells", spell, "area")
      end

      def targets
        Global.read_config("spells", spell, "target_num")
      end

      def heal
        Global.read_config("spells", spell, "heal_points")
      end

      def defense_mod
        Global.read_config("spells", spell, "defense_mod")
      end

      def attack_mod
        Global.read_config("spells", spell, "attack_mod")
      end

      def lethal_mod
        Global.read_config("spells", spell, "attack_mod")
      end

      def spell_mod
        Global.read_config("spells", spell, "spell_mod")
      end

      def weapon
        Global.read_config("spells", spell, "weapon")
      end

    end
  end
end

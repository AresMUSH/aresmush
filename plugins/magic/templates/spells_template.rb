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

      def item_spells
        Magic.item_spells(char)
      end

      def item_spell_display(spell)
        level = Global.read_config("spells", spell, "level")
        school = Global.read_config("spells", spell, "school")
        "#{left( spell, 29 )} Level #{level} #{school} spell"
      end

      def other_spell_display(spell)
        level = Global.read_config("spells", spell.name, "level")
        school = Global.read_config("spells", spell.name, "school")
        "#{left( spell.name, 29 )} Level #{level} #{school} spell"
      end

      def days_left(spell)
        time_left = Magic.days_to_next_learn_spell(spell)
        message = time_left <= 0 ? t('fs3skills.xp_days_now') : t('fs3skills.xp_days', :days => time_left)
        center(message, 13)
      end

      def detail(spell)
        total_xp_needed = Magic.spell_xp_needed(spell.name)
        xp = total_xp_needed - spell.xp_needed
        detail = "(#{xp + 1}/#{total_xp_needed + 1})"
        detail.ljust(10)
      end

      def progress(spell)
        Global.logger.debug "SPELL: #{spell.name}"
        total_xp_needed = Magic.spell_xp_needed(spell.name) + 1
        xp = (total_xp_needed - spell.xp_needed)
        ProgressBarFormatter.format(xp, total_xp_needed)
      end

      def display(spell)
        "#{left(spell.name, 30)} #{spell.level} #{right(progress(spell), 18)} #{detail(spell)} #{days_left(spell)}"
      end

      def xp
        char.xp
      end

    end
  end
end

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

      def magic_energy
        ProgressBarFormatter.format(char.magic_energy, char.total_magic_energy)
      end

      def magic_energy_percent
        current = char.magic_energy
        total = char.total_magic_energy
        puts "Current: #{current} Total: #{total}"
        ((current.to_f/total.to_f)*100).to_i
      end

      def spell_fatigue_degree
        Magic.get_fatigue_level(char)[:degree]
      end

      def spell_fatigue_msg
        Magic.get_fatigue_level(char)[:msg]
      end

      def spells_learned
        @char.spells_learned.to_a
      end

      def spells_learned_list
        self.spells_learned.select { |s| s.learning_complete}.sort_by { |s| s.level }
      end

      def spells_still_learning_list
        spells = self.spells_learned.select { |s| !s.learning_complete}.sort_by { |s| s.level }
        spells.empty? ? spells = nil : spells = spells
        spells
      end

      def spell_max
        Magic.spell_max
      end

      def spells_for_school(school)
        spells_learned_list.select {|s| s.school == school  }
      end

      def still_learning_spells_for_school(school)
        spells_still_learning_list.select {|s| s.school == school  }
      end

      def spell_display(spell)
        "#{left(spell.name, 30)} #{left(spell.level, 40)}"
      end

      def spell_display_w_school(spell)
        spell = spell.name
        level = Global.read_config("spells", spell, "level")
        school = Global.read_config("spells", spell, "school")
        "#{left( spell, 29 )} Level #{level} #{school} spell"
      end

      def item_spells
        Magic.item_spells(char)
      end

      def other_spells
        spells_learned_list.select { |s| !char.major_schools.include?(s.school) && !char.minor_schools.include?(s.school)}
      end

      def days_left(spell)
        time_left = Magic.days_to_next_learn_spell(spell)
        message = time_left <= 0 ? t('fs3skills.xp_days_now') : t('fs3skills.xp_days', :days => time_left)
        center(message, 13)
      end

      def detail(spell)
        total_xp_needed = Magic.spell_xp_needed(spell.name)
        xp = total_xp_needed - spell.xp_needed
        detail = "(#{xp}/#{total_xp_needed})"
        detail.ljust(10)
      end

      def progress(spell)
        Global.logger.debug "SPELL: #{spell.name}"
        total_xp_needed = Magic.spell_xp_needed(spell.name)
        xp = (total_xp_needed - spell.xp_needed)
        ProgressBarFormatter.format(xp, total_xp_needed)
      end

      def display_learning(spell)
        "#{left(spell.name, 30)} #{spell.level} #{right(progress(spell), 18)} #{detail(spell)} #{days_left(spell)}"
      end

      def xp
        char.xp
      end

    end
  end
end

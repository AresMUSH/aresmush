module AresMUSH
  module Custom
    def self.can_learn_spell?(char, spell)
      self.time_to_next_learn <= 0
    end

    def self.time_to_next_learn_spell(char, spell)
      return 0 if !spell.last_learned
      time_left = (FS3Skills.days_between_learning * 86400) - (Time.now - spell.last_learned)
      [time_left, 0].max
    end

    def self.find_spell_learned (char, spell)
      spell_name = spell.titlecase
      char.spells_learned.select { |a| a.name == spell_name }.first
    end

    def self.already_learned(spell)
    end

    def self.spell_xp_needed(spell)
      level = Global.read_config("spells", spell, "level")
      if level <= 2
        xp_needed = 1
      elsif level == 3
        xp_needed = 3
      else
        xp_needed = 4
      end
    end

  end
end

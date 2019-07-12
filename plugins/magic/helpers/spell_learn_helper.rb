module AresMUSH
  module Magic

    def self.knows_spell?(char_or_combatant, spell_name)
      spell_name = spell_name.titlecase
      if char_or_combatant.combat && char_or_combatant.is_npc?
        return true
      elsif char_or_combatant.combat && !char_or_combatant.is_npc?
        char = char_or_combatant.associated_model
      else
        char = char_or_combatant
      end

      if char.spells_learned.select { |a| (a.name == spell_name && a.learning_complete == true) }.first
        return true
      else
        return false
      end
    end

    def self.knows_potion?(char)
      spell_names = char.spells_learned.map { |s| s.name }
      list = spell_names.join " "
      potion = list.include?("Potions")
      return potion
    end

    def self.count_spells_total(char)
      spells_learned = char.spells_learned.select { |l| l.learning_complete }
      spells_learned.count
    end

    def self.count_spells_learning(char)
      spells_learned = char.spells_learned.select { |l| !l.learning_complete }
      spells_learned.count
    end

    #Gives time in seconds
    def self.time_to_next_learn_spell(spell)
      (7 * 86400) - (Time.now - spell.last_learned)
    end

    def self.find_spell_learned(char, spell_name)
      spell_name = spell_name.titlecase
      char.spells_learned.select { |a| a.name == spell_name }.first
    end

    def self.previous_level_spell?(char, spell_name)
      spell_name = spell_name.titlecase
      spell_level = Magic.find_spell_level(char, spell_name)
      school = Magic.find_spell_school(char, spell_name)
      level_below = spell_level.to_i - 1
      spells_learned =  char.spells_learned.to_a
      if spells_learned.any? {|s| s.level == level_below && s.school == school && s.learning_complete == true}
        return true
      elsif spell_level == 1
        return true
      else
        return false
      end
    end

    def self.higher_level_spell?(char, spell_name)
      spell_name = spell_name.titlecase
      spell_level = Magic.find_spell_level(char, spell_name)
      school = Magic.find_spell_school(char, spell_name)
      level_above = spell_level.to_i + 1
      spells_learned =  char.spells_learned.to_a

      if spells_learned.any? {|s| s.level == level_above && s.school == school && s.learning_complete == true}
        return true
      else
        return false
      end
    end

    def self.can_discard?(char, spell)
      level = spell.level
      school = spell.school
      spells_learned =  char.spells_learned.to_a
      if_discard = spells_learned.delete(spell)
      if spells_learned.any? {|s| s.level > level && s.school == school}
        if spells_learned.any? {|s| s.level == level && s.school == school}
          return true
        else
          return false
        end
      else
        return true
      end
    end

    def self.spell_xp_needed(spell)
      level = Global.read_config("spells", spell, "level")
      if level == 1
        xp_needed = 1
      elsif level == 2
        xp_needed = 2
      elsif level == 3
        xp_needed = 3
      elsif level == 4
        xp_needed = 4
      elsif level == 5
        xp_needed = 5
      elsif level == 6
        xp_needed = 6
      elsif level == 7
        xp_needed = 7
      elsif level == 8
        xp_needed = 13
      end
    end

  end
end

module AresMUSH
  module Magic

    def self.add_spell(char, spell_name)
      spell_level = Global.read_config("spells", spell_name, "level")
      school = Global.read_config("spells", spell_name, "school")
      SpellsLearned.create(name: spell_name.strip, last_learned: Time.now, level: spell_level, school: school, character: char, xp_needed: 0, learning_complete: true)
    end

    def self.new_char_can_learn(char, spell)
      return false if Magic.new_spells_time_left(char) <= 0
      num = Global.read_config("magic", "cg_spell_max")
      return false if char.spells_learned.count >= num
      max_level = Global.read_config("magic", "cg_max_spell_level")
      return false if Global.read_config("spells", spell, "level") > max_level
      return false if !char.schools.keys.include?(Global.read_config("spells", spell, "school"))
      return false if !Magic.previous_level_spell?(char, spell)
      return true
    end

    def self.new_spells_time_left(char)
      days_after_approval = Global.read_config("magic", "cg_days_to_choose_spells")
      secs = days_after_approval * 86400
      #Need to change this to approved_at once it's in core
      days_left = ((char.created_at + secs) - Time.now) / 86400
      days_left.round()
    end

    def self.delete_all_spells(char)
      char.spells_learned.each do |s|
        s.delete
      end
    end

    def self.knows_spell?(char_or_combatant, spell_name)
      spell_name = spell_name.titlecase
      return true if (char_or_combatant.is_npc?)
      char = Magic.get_associated_model(char_or_combatant)
      # if (char_or_combatant.class == Combatant && char_or_combatant.is_npc?)
      #   return true
      # elsif (char_or_combatant.class == Combatant && !char_or_combatant.is_npc?)
      #   char = char_or_combatant.associated_model
      # else
      #   char = char_or_combatant
      # end

      item_spells = Magic.item_spells(char)

      if char.spells_learned.select { |a| (a.name == spell_name && a.learning_complete == true) }.first || item_spells.include?(spell_name)
        return true
      else
        return false
      end
    end

    def self.num_can_learn(char)
      num = 1
      char.major_schools.each do |s|
        rating = FS3Skills.ability_rating(char, s)
        num = rating if rating > num
      end
      return num
    end

    def self.knows_potion?(char)
      spell_names = char.spells_learned.map { |s| s.name }
      item_spells = Magic.item_spells(char)
      list = spell_names.join " "
      potion_spell = Global.read_config("magic", "potion_spell")
      potion = list.include?(potion_spell) || item_spells.include?(potion_spell)
      return potion
    end

    def self.count_spells_total(char)
      spells_learned = char.spells_learned.select { |s| char.major_schools.include?(s.school) || char.minor_schools.include?(s.school)}
      spells_learned.count
    end

    def self.count_spells_learning(char)
      spells_learned = char.spells_learned.select { |l| !l.learning_complete }
      spells_learned.count
    end

    #Gives time in seconds
    def self.time_to_next_learn_spell(spell)
      days = Global.read_config("magic", "days_between_learning_spells")
      (days * 86400) - (Time.now - spell.last_learned)
    end

    def self.days_to_next_learn_spell(spell)
      time = Magic.time_to_next_learn_spell(spell)
      (time / 86400).ceil
    end

    def self.find_spell_learned(char, spell_name)
      spell_name = spell_name.titlecase
      char.spells_learned.select { |a| a.name == spell_name }.first
    end

    def self.previous_level_spell?(char, spell_name)
      spell_name = spell_name.titlecase
      spell_level = Magic.find_spell_level(char, spell_name)
      school = Magic.find_spell_school(spell_name)
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

    def self.equal_level_spell?(char, spell_name)
      spell_name = spell_name.titlecase
      spell_level = Magic.find_spell_level(char, spell_name)
      school = Magic.find_spell_school( spell_name)
      spells_learned =  char.spells_learned.to_a

      if spells_learned.any? {|s| s.level == spell_level && s.school == school && s.learning_complete == true}
        return true
      else
        return false
      end
    end

    def self.can_discard?(char, spell)
      
      return true if spell.level == 1
      level = spell.level
      school = spell.school
      spells_learned =  char.spells_learned.to_a
      spells_learned.delete(spell)
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
      return Global.read_config("magic", "xp_per_level", level)
    end

  end
end

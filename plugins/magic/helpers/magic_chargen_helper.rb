require 'byebug'
module AresMUSH
  module Magic

    def self.points_on_spells(char)
      spells = Magic.starting_spells(char)
      points = 0
      spells.each do |s|
        points = points + s[:level]
      end
      points
    end

    def self.check_magic_attribute_rating(char)
      magic = FS3Skills.ability_rating(char, "Magic")
      if magic > 3
        error = "%xr< Your Magic attribute cannot be higher than 3. >%xn"
      else
        error = t('chargen.ok')
      end
      return {
        msg: 'Checking Magic',
        error: error
        }
    end
    
    def self.check_points_on_spells(char)
      if Magic.points_on_spells(char) > 25
        error = "%xr< You cannot spend more than 25 points on spells. >%xn"
      else
        error = t('chargen.ok')
      end
      return  {
        msg: 'Checking Spells',
        error: error
        }

    end

    def self.cg_max_points_by_age(char)
      default_points = Global.read_config("fs3skills", "max_ap")
      if !char.age || char.age < 25
        points = default_points
      elsif (26..35).include? char.age 
        points = default_points + 5
      elsif (36..45).include? char.age 
        points = default_points + 10
      elsif char.age > 45
        points = default_points + 15
      end
    end

    def self.check_cg_spell_errors(char)
      errors = []
      errors.concat Magic.check_wrong_school(char)
      errors.concat Magic.check_wrong_levels(char)
      errors.concat Magic.check_spell_numbers(char)
      return errors
    end

    def self.check_spell_numbers(char)
      num = Global.read_config("magic", "cg_spell_max")
      return [t('magic.too_many_spells_cg', :num => num)] if char.spells_learned.count > num
      return []
    end

    def self.check_wrong_school(char)
      spell_schools = char.spells_learned.map {|s| s.school}
      return [t('magic.wrong_school_cg')] if !spell_schools.all? { |s| char.schools.include?(s)}
      return []
    end

    def self.check_wrong_levels(char)
      spell_names = char.spells_learned.map {|s| s.school}
      spell_names.each do |s|
        return [t('magic.wrong_level_cg')] if !Magic.previous_level_spell?(char, s) 
      end
      return []
    end

    def self.starting_spell_names(starting_spell_data)
      return nil if !starting_spell_data
      spells = starting_spell_data.values
      names = []
      spells.each do |spell|
        names << spell['name']
      end
      names
    end

    def self.save_major_school(char, major_school)
      schools = char.schools
      old = schools.select{|k,v| v == "Major"}
      schools.delete(old.keys[0])
      schools["#{major_school}"] = "Major"
      char.update(schools: schools)
    end

    def self.save_minor_school(char, minor_school)
      schools = char.schools
      old = schools.select{|k,v| v == "Minor"}
      schools.delete(old.keys[0])
      schools["#{minor_school}"] = "Minor"
      char.update(schools: schools)
    end

    def self.cg_spells(char)
      level = Global.read_config("magic", "cg_max_spell_level")
      spells = Global.read_config("spells").values.select { |s| s['level'] <= level }
      spells = spells.select { |s| char.schools.include?(s['school'])} if !char.schools.empty?

      cg_spells = []

      spells.each do |k, v|
        cg_spells << { name: k['name'], school: k['school'], level: [k['level']] }
      end
      cg_spells.sort_by { |s| [s[:school], s[:level]] }
    end

    def self.mage_cg_spells(char)
      level = Global.read_config("magic", "cg_max_spell_level")
      spells = Global.read_config("spells").values.select { |s| s['level'] <= level }
      spells = spells.select { |s| (s['school'] == "Creation" || s['school'] == "Arcane")} 

      cg_spells = []

      spells.each do |k, v|
        cg_spells << { name: k['name'], school: k['school'], level: [k['level']] }
      end
      cg_spells.sort_by { |s| [s[:school], s[:level]] }
    end

    def self.mythic_cg_spells(char)
      level = Global.read_config("magic", "cg_max_spell_level")
      spells = Global.read_config("spells").values.select { |s| s['level'] <= level }
      spells = spells.select { |s| (s['school'] == "Aether" || s['school'] == "Entropy")} 

      cg_spells = []

      spells.each do |k, v|
        cg_spells << { name: k['name'], school: k['school'], level: [k['level']] }
      end
      cg_spells.sort_by { |s| [s[:school], s[:level]] }
    end

    def self.starting_spells(char)
      spells = char.spells_learned.to_a.select {|s| s.learning_complete == true}
      starting_spells = []

      spells.each do |spell|
        starting_spells << { name: spell.name, school: spell.school, level: spell.level }
      end
      starting_spells.sort_by { |s| [s[:school], s[:level]] }
    end

    def self.mage_starting_spells(char)
      spells = char.spells_learned.to_a.select {|s| (s.learning_complete == true &&  (s['school'] == "Arcane" || s['school'] == "Creation"))}
      starting_spells = []

      spells.each do |spell|
        starting_spells << { name: spell.name, school: spell.school, level: spell.level }
      end
      starting_spells.sort_by { |s| [s[:school], s[:level]] }
    end

    def self.mythic_starting_spells(char)
      spells = char.spells_learned.to_a.select {|s| (s.learning_complete == true) &&  (s['school'] == "Aether" || s['school'] == "Entropy")}
      starting_spells = []

      spells.each do |spell|
        starting_spells << { name: spell.name, school: spell.school, level: spell.level }
      end
      starting_spells.sort_by { |s| [s[:school], s[:level]] }
    end

    def self.save_starting_spells(char, spells)
      if spells.nil?
        Magic.delete_all_spells(char)
      else
        starting_spells = Magic.starting_spells(char).map {|s| s[:name]}
        starting_spells.each do |s|
          puts "Checking whether to delete a spell in CG. #{s}"
          if !spells.include?(s)
            spell = Magic.find_spell_learned(char, s)
            spell.delete
          end
        end

        spells.each do |spell|
          if !starting_spells.include?(spell)
          puts "Adding a new spell #{spell} - #{spell.titlecase}"
            Magic.add_spell(char, spell.titlecase)
          end
        end
      end
    end


  end
end
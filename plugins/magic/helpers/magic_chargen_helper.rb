require 'byebug'
module AresMUSH
  module Magic

    def self.check_cg_spell_errors(char)
      errors = []
      errors.concat Magic.check_wrong_school(char)
      errors.concat Magic.check_wrong_levels(char)
      errors.concat Magic.check_spell_numbers(char)
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
      puts "Data: #{starting_spell_data}"
      return nil if !starting_spell_data
      spells = starting_spell_data.values
      puts "Spells:  #{spells}"
      names = []
      spells.each do |spell|
        puts "Spell: #{spell}"
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

    def self.starting_spells(char)
      spells = char.spells_learned.to_a.select {|s| s.learning_complete == true}
      starting_spells = []

      spells.each do |spell|
        starting_spells << { name: spell.name, school: spell.school, level: spell.level }
      end
      starting_spells.sort_by { |s| [s[:school], s[:level]] }
    end

    def self.save_starting_spells(char, spells)
      puts spells
      if spells.nil?
        Magic.delete_all_spells(char)
      else
        starting_spells = Magic.starting_spells(char).map {|s| s[:name]}
        puts "Starting spell names #{starting_spells}"
        starting_spells.each do |s|
          puts "Checking whether to delete a spell in CG. #{s}"
          puts "Spells names #{spells}"
          if !spells.include?(s)
            spell = Magic.find_spell_learned(char, s)
            puts "Deleting spell #{spell.name}"
            spell.delete
          end
        end

        spells.each do |spell|
          puts "Checking to see whether we should create a new spell #{spell}"
          
          if !starting_spells.include?(spell)
          puts "Adding a new spell #{spell} - #{spell.titlecase}"
            Magic.add_spell(char, spell.titlecase)
          end
        end
      end
    end


  end
end
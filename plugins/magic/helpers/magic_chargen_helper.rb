require 'byebug'
module AresMUSH
  module Magic

    def self.points_on_spells(char)
      spells = Magic.starting_spells(char)
      points = 0
      spells.each do |s|
        points = points + (s[:level].to_f * 0.5)
      end
      points
    end

    # CHECKING ERRORS FOR CG ALERTS AND APP REVIEW
    def self.check_cg_spell_errors(char)
      errors = []
      errors.concat [Magic.check_points_on_spells(char)[:error]]
      errors.concat [Magic.check_wrong_school(char)[:error]]
      errors.concat [Magic.check_wrong_levels(char)[:error]]
      errors.concat [Magic.check_points_on_spells(char)[:error]]
      # errors.concat Magic.check_spell_numbers(char)
      puts "Errors 1 #{errors}"
      errors = errors.reject { |e| e == "%xh%xg< OK! >%xn"}
      puts "Errors 2 #{errors}"
      return errors
    end

    def self.check_spell_numbers(char)
      num = Global.read_config("magic", "cg_spell_max")
      return [t('magic.too_many_spells_cg', :num => num)] if char.spells_learned.count > num
      return []
    end

    def self.check_wrong_school(char)
      spell_schools = char.spells_learned.map {|s| s.school}
      if !spell_schools.all? { |s| char.schools.include?(s)}
        return {
          error: t('magic.wrong_school_cg'),
          msg: "Checking Spell Schools",
        }
      end
      return {
        error: t('chargen.ok'),
        msg: 'Checking Spell Schools',
      }
    end

    def self.check_wrong_levels(char)
      spell_names = char.spells_learned.map {|s| s.name}
      spell_names.each do |s|
        if !Magic.previous_level_spell?(char, s)
          puts "No previous level: #{s}"
          return {
            error: t('magic.wrong_level_cg'),
            msg: 'Checking Spell Levels',
          }
        end
      end

      return {
        error: t('chargen.ok'),
        msg: 'Checking Spell Levels',
      }

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
      points = 20
      if Magic.points_on_spells(char) > points
        error = t('magic.too_many_points', :num => points)
      else
        error = t('chargen.ok')
      end
      return  {
        msg: 'Checking Spell Points',
        error: error
        }

    end

    # --------------

    def self.cg_max_points_by_age(char)
      default_points = Global.read_config("fs3skills", "max_ap")
      if !char.age || char.age < 25
        points = default_points
      elsif (26..30).include? char.age
        points = default_points + 3
      elsif (31..35).include? char.age
        points = default_points + 6
      elsif (36..40).include? char.age
        points = default_points + 9
      elsif (41..45).include? char.age
        points = default_points + 12
      elsif char.age > 45
        points = default_points + 15
      end
    end



    def self.starting_spell_names(custom_chargen_data)
      return nil if !custom_chargen_data

      if custom_chargen_data[:mage_starting_spells] && !custom_chargen_data[:mythic_starting_spells]
        spells = custom_chargen_data[:mage_starting_spells].values
      elsif !custom_chargen_data[:mage_starting_spells] && custom_chargen_data[:mythic_starting_spells]
        spells = custom_chargen_data[:mythic_starting_spells].values
      elsif custom_chargen_data[:mage_starting_spells] && custom_chargen_data[:mythic_starting_spells]
        spells = custom_chargen_data[:mage_starting_spells].values.concat custom_chargen_data[:mythic_starting_spells].values
      else
        return nil
      end

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
      spells = char.spells_learned.to_a.select {|s| (s.learning_complete == true &&  (s.school == "Arcane" || s.school == "Creation"))}
      starting_spells = []

      spells.each do |spell|
        starting_spells << { name: spell.name, school: spell.school, level: spell.level }
      end
      starting_spells.sort_by { |s| [s[:school], s[:level]] }
    end

    def self.mythic_starting_spells(char)
      spells = char.spells_learned.to_a.select {|s| (s.learning_complete == true) &&  (s.school == "Aether" || s.school == "Entropy")}
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
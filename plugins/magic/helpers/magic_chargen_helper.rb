require 'byebug'
module AresMUSH
  module Magic

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

    def self.cg_spells
      all_spells = Global.read_config("spells")
      all_spells.values.select { |s| s['level'] < 5}.map {|s| s['name']}
    end

    def self.starting_spells(char)
      char.spells_learned.to_a.select {|s| s.learning_complete == true}.map {|s| s.name}
    end

    def self.save_starting_spells(char, spells)
      Magic.starting_spells(char).each do |s|
        s.delete if !spells.include(s)
      end

      spells.each do |spell|
        Magic.add_spell(char, spell) if !Magic.starting_spells(char).include?(spell)
      end
    end

  end
end
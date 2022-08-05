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


  end
end
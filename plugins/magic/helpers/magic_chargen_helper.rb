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
        s.delete if !spells.include?(s)
      end

      spells.each do |spell|
        Magic.add_spell(char, spell) if !Magic.starting_spells(char).include?(spell)
      end
    end

    def self.mount_name(char)
      char.bonded.name if char.bonded
    end

    def self.mount_type(char)
      char.bonded.mount_type if char.bonded
    end

    def self.mount_desc(char)
      char.bonded.description if char.bonded
    end

    def self.mount_shortdesc(char)
      char.bonded.shortdesc if char.bonded
    end

    def self.save_mount(char, chargen_data)
      if char.bonded
        mount = char.bonded
        mount.update(mount_type: chargen_data[:custom][:mount_type])
        mount.update(name: chargen_data[:custom][:mount_name])
        mount.update(description: chargen_data[:custom][:mount_desc])
        mount.update(shortdesc: chargen_data[:custom][:mount_shortdesc])
      else
        mount = Mount.create(bonded: char, name: chargen_data[:custom][:mount_name], mount_type: chargen_data[:custom][:mount_type], description: chargen_data[:custom][:mount_desc], shortdesc: chargen_data[:custom][:mount_shortdesc])
        char.update(bonded: mount)
      end
    end

  end
end
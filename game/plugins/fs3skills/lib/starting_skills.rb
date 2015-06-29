module AresMUSH
  module FS3Skills
    module StartingSkills
      def self.config
        Global.read_config("fs3skills", "starting_skills")
      end
      
      def self.get_groups_for_char(char)
        groups = {}
        config.each do |group, group_config|
          if (group == "Everyone")
            groups[group] = group_config
          else
            group_val = char.groups[group]
            next if group_val.nil?
            group_key = group_config.keys.find { |k| k.downcase == group_val.downcase }
            groups[group_val] = group_config[group_key]
          end
        end
        groups
      end 
      
      def self.get_skills_for_char(char)
        skills = {}
        get_groups_for_char(char).each do |k, v|
          group_skills = v["skills"]
          next if group_skills.nil?
          group_skills.each do |skill, rating|
            if (!skills.has_key?(skill) || skills[skill] < rating)
              skills[skill] = rating
            end
          end
        end
        skills
      end 
    end
  end
end
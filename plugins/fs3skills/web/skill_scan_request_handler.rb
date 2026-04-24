module AresMUSH
  module FS3Skills
    class SkillScanRequestHandler
      def handle(request)        
        {
          action: group_levels(FS3ActionSkill, 8),
          background: group_levels(FS3BackgroundSkill, 3),
          language: group_levels(FS3Language, 3),
          advantage: FS3Skills.use_advantages? ? group_levels(FS3Advantage, 3) : nil,
          specialties: group_specialties
        }
      end
      
      def group_levels(type, levels)
        groups = type.all
           .select { |s| s.character && ((s.character.is_approved? && s.character.is_active?) || s.character.on_roster?) }
           .group_by { |a| a.name }
           .sort
           
           
        skill_list = {}
        groups.each do |skill_name, skills|
          skill_list[skill_name] = {}
          levels.times.each do |lvl|
            skill_list[skill_name][lvl + 1] = skills
               .select { |s| s.rating == lvl + 1}
               .map { |s| s.character.name }
          end
        end
        skill_list
      end
      
      def group_specialties
        groups = FS3ActionSkill.all
           .select { |s| s.character && ((s.character.is_approved? && s.character.is_active?) || s.character.on_roster?) }
           .group_by { |a| a.name }
           .sort
           
        skill_list = {}
        groups.each do |skill_name, skills|
          specialties = FS3Skills.action_specialties(skill_name)
          next if !specialties
          skill_list[skill_name] = {}
          specialties.each do |spec|
            skill_list[skill_name][spec] = skills
               .select { |s| s.specialties.include?(spec)}
               .map { |s| s.character.name }
          end
        end
        skill_list           
      end
            
      def specialty_list(type, skill)
        if (type == FS3ActionSkill)
          skill.specialties.any? ? "(#{skill.specialties.join(',')})" : ""
        else
          ""
        end
      end
      
      
    end
  end
end



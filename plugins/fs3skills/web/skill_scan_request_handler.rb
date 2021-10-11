module AresMUSH
  module FS3Skills
    class SkillScanRequestHandler
      def handle(request)        
        {
          action: group_levels(FS3ActionSkill, 8),
          background: group_levels(FS3BackgroundSkill, 3),
          language: group_levels(FS3Language, 3),
          advantage: FS3Skills.use_advantages? ? group_levels(FS3Advantage, 3) : nil,
        }
      end
      
      
      def select_skills(type)
        
      end
      
      def group_levels(type, levels)
        groups = type.all
           .select { |s| s.character && s.character.is_approved? && s.character.is_active? }
           .group_by { |a| a.name }
           .sort
           
        everybody = {}
        groups.each do |name, skills|
          everybody[name] = {}
          levels.times.each do |lvl|
            everybody[name][lvl + 1] = skills
               .select { |s| s.rating == lvl + 1}
               .map { |s| s.character.name }
          end
        end
        everybody
      end
    end
  end
end



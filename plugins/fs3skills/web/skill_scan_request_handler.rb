module AresMUSH
  module FS3Skills
    class SkillScanRequestHandler
      def handle(request)        
        {
          action: group_levels(FS3ActionSkill.all.group_by { |a| a.name }.sort, 8),
          background: group_levels(FS3BackgroundSkill.all.group_by { |a| a.name }.sort, 3),
          language: group_levels(FS3Language.all.group_by { |a| a.name }.sort, 3),
          advantage: FS3Skills.use_advantages? ? group_levels(FS3Advantage.all.group_by { |a| a.name }.sort, 3) : nil,
        }
      end
      
      def group_levels(groups, levels)
        everybody = {}
        groups.each do |name, skills|
          everybody[name] = {}
          levels.times.each do |lvl|
            everybody[name][lvl + 1] = skills
               .select { |s| s.character && s.character.is_approved? && s.rating == lvl + 1}
               .map { |s| s.character.name }
          end
        end
        everybody
      end
    end
  end
end



module AresMUSH
  module Ffg  
    
    def self.app_review(char)
      if (!char.ffg_archetype || !char.ffg_career)
        return Chargen.format_review_status t('ffg.must_set_archetype'), t('chargen.not_set')
      end
      
      text = Ffg.skill_review(char)
      text << "%r"
      text
    end
      
    def self.skill_review(char)
       config = Ffg.find_career_config(char.ffg_career)
       career_skills = config['career_skills'] || []
       taken = career_skills.count { |skill| Ffg.skill_rating(char, skill) > 0}
       min = Global.read_config('ffg', 'min_career_skills')
       message = t('ffg.career_skills_taken', :taken => taken, :min => min)
       status = taken >= min ? t('chargen.ok') : t('chargen.not_enough')
       Chargen.format_review_status message, status
    end
  end
end
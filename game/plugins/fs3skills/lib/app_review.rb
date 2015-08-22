module AresMUSH
  module FS3Skills
    
    def self.interests_review(char)
      num_skills = char.interests.count
      min = Global.read_config("fs3skills", "min_interests")
      error = num_skills >= min ? t('chargen.ok') : t('chargen.not_enough')
      Chargen.display_review_status(t('fs3skills.interests_added', :num => num_skills, :min => min), error)
    end
    
    def self.hook_review(char)
      Chargen.display_review_status t('fs3skills.hooks_added'), char.fs3_hooks.blank? ? t('chargen.not_set') : t('chargen.ok')
    end
    
    def self.goals_review(char)
       Chargen.display_review_status t('fs3skills.goals_added'), char.fs3_goals.blank? ? t('chargen.not_set') : t('chargen.ok')
    end
    
    def self.interests_review(char)
      FS3Skills.min_item_review(char.fs3_interests, "min_interests", "fs3skills.interests_added")
    end

    def self.high_ability_review(char)
      high_rating = Global.read_config("fs3skills", "high_ability_level")
      count = FS3Skills.num_high_abilities(char, :action, high_rating)
      
      max = Global.read_config("fs3skills", "max_high_abilities")
      
      error = count > max ? t('chargen.too_many') : t('chargen.ok')
      
      Chargen.display_review_status(t('fs3skills.high_abilities', :high_rating => high_rating, :num => count, :max => max), error)
    end
    
    def self.points_on_rated_abilities(char)
      action = FS3Skills.points_on_abilities(char, :action)
      advantages = FS3Skills.points_on_abilities(char, :advantage)
      action + advantages
    end
    
    def self.points_on_interests(char)
      num_interests = char.fs3_interests.count
      free_interests = Global.read_config("fs3skills", "free_interests")
      interest_points = [ (num_interests - free_interests), 0 ].max
      interest_points
    end
    
    def self.points_on_languages(char)
      num_languages = char.fs3_languages.count
      free_languages = Global.read_config("fs3skills", "free_languages")
      language_points = [ (num_languages - free_languages), 0 ].max
      language_points
    end
    
    def self.points_on_expertise(char)
      num_expertise = char.fs3_expertise.count
      expertise_points = num_expertise * 2
      expertise_points
    end
    
    def self.points_total(char)
      total_points = points_on_rated_abilities(char)+ points_on_interests(char) + 
                     points_on_languages(char) + points_on_expertise(char)
      return total_points
    end
    
    def self.total_point_review(char)
      points =  points_total(char)
      
      max = Global.read_config("fs3skills", "starting_points")
      error = points > max ? t('chargen.too_many') : t('chargen.ok')
      Chargen.display_review_status(t('fs3skills.total_points_spent', :total => points, :max => max), error)
    end
    
    def self.aptitudes_set_review(char)
      hash = FS3Skills.get_ability_hash_for_type(char, :aptitude)
      ratings = hash.values
      ratings_set = ratings.select { |r| r > 2 }
      error = ratings_set.count > 0 ? t('chargen.ok') : t('chargen.not_set')
      Chargen.display_review_status(t('fs3skills.aptitudes_check'), error)
    end
      
    def self.starting_language_review(char)
      starting_languages = Global.read_config("fs3skills", "starting_languages")
      missing = starting_languages.select { |l| !char.fs3_languages.include?(l) }
      error = missing.count > 0 ? t('chargen.are_you_sure', :missing => missing.join(" ")) : t('chargen.ok')
      Chargen.display_review_status(t('fs3skills.language_check'), error)
    end
    
    def self.starting_skills_check(char)
      message = t('fs3skills.starting_skills_check')
      missing = []
      starting_skills = StartingSkills.get_skills_for_char(char)
      starting_skills.each do |skill, rating|
        if (FS3Skills.ability_rating(char, skill)) < rating
          missing << t('fs3skills.missing_starting_skill', :skill => skill, :rating => rating) 
        end
      end
      
      if (missing.count == 0)
        Chargen.display_review_status(message, t('chargen.ok'))
      else
        error = missing.collect { |m| "%T#{m}" }.join("%R")
        "#{message}%r#{error}"
      end
    end
    
    def self.points_on_abilities(char, type)
      hash = FS3Skills.get_ability_hash_for_type(char, type)
      ratings = hash.values
      ratings.inject(0) { |sum, a| sum + a }
    end
    
    def self.num_high_abilities(char, type, high_rating)
      hash = FS3Skills.get_ability_hash_for_type(char, type)
      ratings = hash.values
      ratings.inject(0) { |count, a| count + (a >= high_rating ? 1 : 0) }
    end
    
    def self.min_item_review(items, min_config_option_name, prompt)
      num = items.count
      min = Global.read_config("fs3skills", min_config_option_name)
      if (num < min)
        error = t('chargen.not_enough')
      else
        error = t('chargen.ok')
      end
      Chargen.display_review_status(t(prompt, :num => num, :min => min), error)
    end
    
  end
end
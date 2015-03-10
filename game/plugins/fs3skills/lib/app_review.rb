module AresMUSH
  module FS3Skills
    
    def self.points_on_abilities(char, type)
      hash = FS3Skills.get_ability_hash(char, type)
      ratings = hash.values.map { |a| a["rating"] }
      ratings.inject(0) { |sum, a| sum + a }
    end
    
    def self.num_high_abilities(char, type, high_rating)
      hash = FS3Skills.get_ability_hash(char, type)
      ratings = hash.values.map { |a| a["rating"] }
      ratings.inject(0) { |count, a| count + (a > high_rating ? 1 : 0) }
    end
    
    def self.attr_review(points)
      max = Global.config["fs3skills"]["max_points_in_attributes"]
      error = points > max ? t('chargen.too_many') : t('chargen.ok')
      Chargen.display_review_status(t('fs3skills.attr_spent', :total => points, :max => max), error)
    end
    
    def self.action_skill_review(points)
      max = Global.config["fs3skills"]["max_points_in_action_skills"]
      error = points > max ? t('chargen.too_many') : t('chargen.ok')
      Chargen.display_review_status(t('fs3skills.action_skills_spent', :total => points, :max => max), error)
    end
    
    def self.bg_skill_review(char)
      num_skills = char.fs3_background_skills.keys.count
      min = Global.config["fs3skills"]["min_background_skills"]
      error = num_skills >= min ? t('chargen.ok') : t('chargen.not_enough')
      Chargen.display_review_status(t('fs3skills.bg_skills_added', :num => num_skills, :min => min), error)
    end
    
    def self.quirk_review(char)
      num_quirks = char.fs3_quirks.keys.count
      min = Global.config["fs3skills"]["min_quirks"]
      max = Global.config["fs3skills"]["max_quirks"]
      if (num_quirks < min)
        error = t('chargen.not_enough')
      elsif (num_quirks > max)
        error = t('chargen.too_many')
      else
        error = t('chargen.ok')
      end
      Chargen.display_review_status(t('fs3skills.quirks_added', :num => num_quirks, :max => max, :min => min), error)
    end
    
    def self.high_ability_review(char)
      high_rating = Global.config["fs3skills"]["high_ability_level"]

      count = FS3Skills.num_high_abilities(char, :attribute, high_rating)
      count += FS3Skills.num_high_abilities(char, :action, high_rating)
      count += FS3Skills.num_high_abilities(char, :background, high_rating)
      
      max = Global.config["fs3skills"]["max_high_abilities"]
      
      error = count > max ? t('chargen.too_many') : t('chargen.ok')
      
      Chargen.display_review_status(t('fs3skills.high_abilities', :high_rating => high_rating, :num => count, :max => max), error)
    end
    
    def self.total_point_review(points)
      max = Global.config["fs3skills"]["starting_points"]
      error = points > max ? t('chargen.too_many') : t('chargen.ok')
      Chargen.display_review_status(t('fs3skills.total_points_spent', :total => points, :max => max), error)
    end
    
    def self.min_attr_review(char)
      missing = FS3Skills.attribute_names.select { |a| !char.fs3_attributes.has_key?(a) }
      error = missing.count > 0 ? t('chargen.oops_missing', :missing => missing.first) : t('chargen.ok')
      Chargen.display_review_status(t('fs3skills.attrs_min_rating_check'), error)
    end
      
    def self.starting_language_review(char)
      starting_languages = Global.config['fs3skills']['starting_languages']
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
        error = missing.collect { |m| "%R%T#{m}" }.join
        "#{message}%r#{error}"
      end
    end
  end
end
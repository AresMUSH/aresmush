module AresMUSH
  module FS3Skills
    
    def self.app_review(char)
      text = FS3Skills.total_point_review(char)
      text << "%r"
      text << FS3Skills.ability_rating_review(char)
      text << "%r"
      text << FS3Skills.backgrounds_review(char)
      text << "%r%r"
      text << FS3Skills.starting_language_review(char)
      text << "%r"
      text << FS3Skills.starting_skills_check(char)
      text << "%r"
      text << FS3Skills.unusual_skills_check(char)
      text << "%r"
      text << FS3Skills.hook_review(char)
      text
    end
    
    def self.hook_review(char)
      FS3Skills.min_item_review(char.fs3_hooks.count, "min_hooks", "fs3skills.hooks_added")      
    end
    
    def self.backgrounds_review(char)
      FS3Skills.min_item_review(char.fs3_background_skills.count, "min_backgrounds", "fs3skills.backgrounds_added")
    end

    def self.ability_rating_review(char)
      too_high = []
      message = t('fs3skills.ability_ratings_check')

      error = FS3Skills.check_high_abilities(char.fs3_action_skills, 5, 
        'max_skills_above_4', 'fs3skills.action_skills_above')
      too_high << error if error
      
      error = FS3Skills.check_high_abilities(char.fs3_action_skills, 7, 
         'max_skills_above_6', 'fs3skills.action_skills_above')
      too_high << error if error

      error = FS3Skills.check_high_abilities(char.fs3_attributes, 4, 
         'max_attr_above_3', 'fs3skills.attributes_above')
      too_high << error if error
      
      error = FS3Skills.check_high_abilities(char.fs3_attributes, 5, 
         'max_attr_above_4', 'fs3skills.attributes_above')
      too_high << error if error

      error = FS3Skills.check_attr_points(char)
      too_high << error if error
      
      
      if (too_high.count == 0)
        Chargen.format_review_status(message, t('chargen.ok'))
      else
        error = too_high.collect { |m| "%T#{m}" }.join("%R")
        "#{message}%r#{error}"
      end
    end
    
    def self.unusual_skills_check(char)
      too_high = []
      message = t('fs3skills.unusual_abilities_check')
      
      all_skills = char.fs3_background_skills.map { |s| s.name }
      all_skills.concat char.fs3_action_skills.select { |s| s.rating > 1 }.map { |s| s.name }
      all_skills.concat char.fs3_languages.map { |s| s.name }
      
      uncommon_skills = Global.read_config("fs3skills", "unusual_skills")
      uncommon_skills.each do |s|
        if (all_skills.include?(s))
          too_high << t('fs3skills.unusual_skill', :skill => s)
        end
      end
          
      char.fs3_background_skills.each do |b|
        if (b.rating > 1)
          too_high << t('fs3skills.high_bg', :skill => b.name)
        end
      end
      
      if (too_high.count == 0)
        Chargen.format_review_status(message, t('chargen.ok'))
      else
        error = too_high.collect { |m| "%T#{m}" }.join("%R")
        "#{message}%r#{error}"
      end
    end
      
    def self.check_attr_points(char)
      points = AbilityPointCounter.points_on_attrs(char)
      max = Global.read_config("fs3skills", "max_attributes")
      points > max ? t('fs3skills.too_many_attributes', :max => max) : nil
    end
        
    def self.total_point_review(char)
      points =  AbilityPointCounter.total_points(char)
      max = Global.read_config("fs3skills", "max_ap")
      error = points > max ? t('chargen.too_many') : t('chargen.ok')
      Chargen.format_review_status(t('fs3skills.total_points_spent', :total => points, :max => max), error)
    end
    
    def self.starting_language_review(char)
      starting_languages = Global.read_config("fs3skills", "starting_languages")
      missing = starting_languages.select { |l| FS3Skills.ability_rating(char, l) < 3 }
      error = missing.count > 0 ? t('chargen.are_you_sure', :missing => missing.join(" ")) : t('chargen.ok')
      Chargen.format_review_status(t('fs3skills.language_check'), error)
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
      
      starting_specs = StartingSkills.get_specialties_for_char(char)
      char.fs3_action_skills.each do |a|
        specs_for_skill = starting_specs[a.name]
        if (specs_for_skill)
          specs_for_skill.each do |s|
            if (!a.specialties.include?(s))        
              missing << t('fs3skills.missing_group_specialty', :spec => s, :skill => a.name)
            end
          end
        end
      end
      
      char.fs3_action_skills.each do |a|
        config = FS3Skills.action_skill_config(a.name)
        if (config['specialties'] && a.specialties.empty? && a.rating > 2)
          missing << t('fs3skills.missing_specialty', :skill => a.name)
        end
      end
      
      
      if (missing.count == 0)
        Chargen.format_review_status(message, t('chargen.ok'))
      else
        error = missing.collect { |m| "%T#{m}" }.join("%R")
        "#{message}%r#{error}"
      end
    end
    
    def self.check_high_abilities(abilities, high_rating, max_config_option_name, prompt)
      ratings = abilities.map { |a| a.rating }
      count = ratings.inject(0) { |count, a| count + (a >= high_rating ? 1 : 0) }
      max = Global.read_config("fs3skills", max_config_option_name)
      if (count > max)
        prompt = t(prompt, :num => count, :max => max, :high_rating => high_rating)
        return prompt
      else
        return nil
      end
    end
    
    def self.min_item_review(count, min_config_option_name, prompt)
      min = Global.read_config("fs3skills", min_config_option_name)
      error = count < min ? t('chargen.not_enough') : t('chargen.ok')
      Chargen.format_review_status(t(prompt, :num => count, :min => min), error)
    end
    
  end
end
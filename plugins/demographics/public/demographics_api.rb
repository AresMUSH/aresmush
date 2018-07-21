module AresMUSH
  module Demographics
    
    def self.basic_demographics
      # Use map here to clone it.
      basic_demographics = Demographics.all_demographics.map { |d| d }
      basic_demographics.delete 'birthdate'
      basic_demographics.delete 'fullname'
      basic_demographics.delete 'actor'
      basic_demographics
    end
            
    def self.required_demographics
      Global.read_config("demographics", "required_properties")
    end
    
    def self.name_and_nickname(char)
      return nil if !char
      nickname_field = Global.read_config("demographics", "nickname_field") || ""
      nickname_format = Global.read_config("demographics", "nickname_format") || "%{name} (%{nickname})"
      
      if (!nickname_field.blank?)
        if (char.demographic(nickname_field))
          nickname_format % { :name => char.name, :nickname => char.demographic(nickname_field) }
        else
          char.name
        end
      else
        char.name
      end
    end
    
    def self.app_review(char)
      message = t('demographics.demo_review')
      
      required_properties = Global.read_config("demographics", "required_properties")
      missing = []
      
      required_properties.each do |property|
        if (!char.demographic(property))
          missing << t('chargen.oops_missing', :missing => property)
        end
      end
      
      if (char.demographic(:gender) == "other")
        missing << "%xy%xh#{t('demographics.gender_set_to_other')}%xn"
      end
      
      age_error = Demographics.check_age(char.age)
      if (age_error)
        missing << "%xr%xh< #{age_error}> %xn"
      end
      
      Demographics.all_groups.keys.each do |g|
        if (char.group(g).nil?)
          missing << t('chargen.are_you_sure', :missing => g)
        end
      end
      
      if (missing.count == 0)
        Chargen.format_review_status(message, t('chargen.ok'))
      else
        error = missing.collect { |m| "%R%T#{m}" }.join
        "#{message}%r#{error}"
      end
    end
      
    def self.gender(char)
      g = char.demographic(:gender) || "Other"
      g.downcase
    end
      
    # His/Her/Their
    def self.possessive_pronoun(char)
      t("demographics.#{gender(char)}_possessive")
    end

    # He/She/They
    def self.subjective_pronoun(char)
      t("demographics.#{gender(char)}_subjective")
    end

    # Him/Her/Them
    def self.objective_pronoun(char)
      t("demographics.#{gender(char)}_objective")
    end
      
    # Man/Woman/Person
    def self.gender_noun(char)
      t("demographics.#{gender(char)}_noun")
    end
  end  
end
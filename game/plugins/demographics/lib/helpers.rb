module AresMUSH
  module Demographics
    def self.get_or_create_demographics(char)
      demographics = char.demographics
      if (!demographics)
        demographics = DemographicInfo.create(character: char)
        char.demographics = demographics
        char.save
      end
      demographics
    end
    
    def self.check_age(age)
      min_age = Global.read_config("demographics", "min_age")
      max_age = Global.read_config("demographics", "max_age")
      if (age > max_age || age < min_age)
        return t('demographics.age_outside_limits', :min => min_age, :max => max_age) 
      end
      return nil
    end
    
    def self.calculate_age(dob)
      return 0 if !dob
      now = ICTime::Api.ictime
      now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
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
      
      if (char.gender == "other")
        missing << "%xy%xh#{t('demographics.gender_set_to_other')}%xn"
      end
      
      if (missing.count == 0)
        Chargen::Api.format_review_status(message, t('chargen.ok'))
      else
        error = missing.collect { |m| "%R%T#{m}" }.join
        "#{message}%r#{error}"
      end
    end
  end
end
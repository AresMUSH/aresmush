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
    
    def self.visible_demographics(char, viewer)
      show_all = viewer && (viewer == char || viewer.has_permission?("manage_demographics"))

      demographics = Demographics.basic_demographics

      if (!show_all)
        Demographics.private_demographics.each do |d|
          demographics.delete d
        end
      end
      
      demographics
    end
            
    def self.required_demographics
      Global.read_config("demographics", "required_properties")
    end

    def self.private_demographics
      Global.read_config("demographics", "private_properties")
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
      now = ICTime.ictime
      now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
    end
    
    def self.set_birthday(model, date_str)
      begin
        bday = Date.strptime(date_str, Global.read_config("datetime", "short_date_format"))
      rescue
        return { error: t('demographics.invalid_birthdate', 
           :format_str => Global.read_config("datetime", "date_entry_format_help")) }
      end
    
      age = Demographics.calculate_age(bday)
      age_error = Demographics.check_age(age)
      if (age_error)
        return { error: age_error }
      end
      
      model.update_demographic(:birthdate, bday)
      return { bday: bday }
    end
    
    def self.set_random_birthdate(model, age)
      bday = Date.new ICTime.ictime.year - age, ICTime.ictime.month, ICTime.ictime.day
      bday = bday - rand(364)
      model.update_demographic :birthdate, bday
      return bday
    end
  end  
end
module AresMUSH
  module Demographics
    
    def self.public_demographics
      demographics = Demographics.all_demographics.select { |d| !Demographics.is_public_demographic?(d) }
      demographics
    end
    
    def self.visible_demographics(char, viewer)
      show_all = viewer && (viewer == char || viewer.has_permission?("manage_demographics"))

      if (show_all)
        Demographics.all_demographics
      else
        Demographics.public_demographics
      end
    end
          
    def self.is_public_demographic?(name)
      Demographics.private_demographics.include?(name)
    end
      
    def self.required_demographics
      Global.read_config("demographics", "required_properties") || []
    end

    def self.private_demographics
      Global.read_config("demographics", "private_properties") || []
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
      
      age_error = Demographics.check_age(char.age)
      if (age_error)
        missing << "%xr%xh< #{age_error}> %xn"
      end
      
      if (char.demographic(:gender) == "other")
        missing << "%xy%xh#{t('demographics.gender_set_to_other')}%xn"
      end
            
      played_by = char.demographic('played by')
      if (played_by)
        duplicate_pb = Chargen.approved_chars.any? { |c| c.demographic('played by') == played_by }
        if (duplicate_pb)
          missing << "%xr%xh#{t('demographics.duplicate_played_by')}%xn"
        end
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
      return nil if !char
      g = char.demographic(:gender) || "Other"
      g.downcase
    end
      
    # His/Her/Their
    def self.possessive_pronoun(char)
      Demographics.gender_config(gender(char))['possessive_pronoun']
    end

    # He/She/They
    def self.subjective_pronoun(char)
      Demographics.gender_config(gender(char))['subjective_pronoun']
    end

    # Him/Her/Them
    def self.objective_pronoun(char)
      Demographics.gender_config(gender(char))['objective_pronoun']
    end
      
    # Man/Woman/Person
    def self.gender_noun(char)
      Demographics.gender_config(gender(char))['noun']
    end
    
    
    def self.check_age(age)
      return nil if !Demographics.age_enabled?
      
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
    
    def self.build_web_profile_data(char, viewer)
      {
        all_fields: Demographics.build_web_all_fields_data(char, viewer),
        demographics: Demographics.build_web_demographics_data(char, viewer),
        groups: Demographics.build_web_groups_data(char)
      }
    end
    
    def self.build_web_profile_edit_data(char, viewer, is_profile_manager)
      demographics = {}
      if (is_profile_manager)
        props = Demographics.all_demographics
      else
        props = Global.read_config('demographics')['editable_properties']
      end
              
      props.each do |d| 
        demographics[d.downcase] = 
          {
            name: d.titlecase,
            value: "#{char.demographic(d)}"
          }
      end
      {
        demographics: demographics,
        genders: Demographics.genders
      }
    end
    
    def self.save_web_profile_data(char, enactor, args)            
      args[:demographics].each do |name, value|
        if (value.blank? && Demographics.required_demographics.include?(name))
          return t('webportal.missing_required_field', :name => name) 
        end
        if (name == 'birthdate')
          # Standard db format
          if (value =~ /\d\d\d\d-\d\d-\d\d/)
            char.update_demographic name, value
          # Game-specific format
          else
            result = Demographics.set_birthday(char, value)
            if (result[:error])
              return result[:error]
            end
          end
        else
          char.update_demographic name, value
        end
      end
      return nil
    end
    
    def self.build_web_demographics_data(char, viewer)
      visible_demographics = Demographics.visible_demographics(char, viewer)
      demographics = []
      
      visible_demographics.each do |d| 
        demographics <<  {
            name: d.titleize,
            key: d.titleize,
            value: "#{char.demographic(d)}"
          }
          
        if (d == "birthdate")
          demographics << { name: t('profile.age_title'), key: 'Age', value: char.age }
        end
      end
    
      demographics
    end
    
    def self.build_web_groups_data(char)
      groups = Demographics.all_groups.keys.sort.map { |g| 
        {
          name: g.titleize,
          value: char.group(g)
        }
      }
    
      if (Ranks.is_enabled?)
        groups << { name: t('profile.rank_title'), key: 'Rank', value: char.rank }
      end
      
      groups
    end
    
    def self.build_web_all_fields_data(char, viewer)
      # Generic demographic/group field list for those who want custom displays.
      all_fields = {}
      visible_demographics = Demographics.visible_demographics(char, viewer)
      visible_demographics.each do |d|
        all_fields[d.gsub(' ', '_')] = char.demographic(d)
        
        if (d == "birthdate")
          all_fields['age'] = char.age
        end
      end
      
      Demographics.all_groups.each do |k, v|
        all_fields[k.downcase] = char.group(k)
      end
      if (Ranks.is_enabled?)
        all_fields['rank'] = char.rank
      end
      all_fields
    end
    
    def self.age_enabled?
      Demographics.all_demographics.include?('birthdate')
    end 
    
    def self.firstname_lastname(char)
      names = char.fullname.split(" ")
      if names.count == 1
        first_name = names[0]
        last_name = ""
      else
        first_name = names[0]
        last_name = names[-1]
      end
      "#{first_name} #{last_name}"
    end
  end  
end
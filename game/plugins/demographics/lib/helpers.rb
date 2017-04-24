module AresMUSH
  module Demographics    

    def self.can_set_demographics?(char)
      char.has_permission?("manage_demographics")
    end

    def self.can_set_group?(char)
      char.has_permission?("manage_demographics")
    end

    def self.all_demographics
      Global.read_config("demographics", "demographics")
    end
    
    def self.all_groups
      Global.read_config("demographics", "groups")
    end
    
    def self.get_group(name)
      return nil if !name
      key = all_groups.keys.find { |g| g.downcase == name.downcase }
      return nil if !key
      return all_groups[key]
    end
    
    def self.census_by(&block)
      counts = {}
      Idle::Api.active_chars.each do |c|
        val = yield(c)
        if (val)
          count = counts.has_key?(val) ? counts[val] : 0
          counts[val] = count + 1
        end
      end
      counts.sort_by { |k,v| v }.reverse
    end
    
    def self.set_group(char, group_name, group)
      groups = char.groups
      groups[group_name] = group
      char.update(groups: groups)      
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
      
      if (char.demographic(:gender) == "other")
        missing << "%xy%xh#{t('demographics.gender_set_to_other')}%xn"
      end
      
      Demographics.all_groups.keys.each do |g|
        if (char.group(g).nil?)
          missing << t('chargen.are_you_sure', :missing => g)
        end
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
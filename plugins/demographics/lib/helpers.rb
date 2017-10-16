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
      Chargen.approved_chars.each do |c|
        val = yield(c)
        if (val)
          count = counts.has_key?(val) ? counts[val] : 0
          counts[val] = count + 1
        end
      end
      counts.sort_by { |k,v| [0-v, k] }
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
      now = ICTime.ictime
      now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
    end
  end
end
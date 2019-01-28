module AresMUSH
  module Demographics    

    def self.can_set_demographics?(char)
      char.has_permission?("manage_demographics")
    end

    def self.can_set_group?(char)
      char.has_permission?("manage_demographics")
    end

    def self.all_demographics
      Global.read_config("demographics", "demographics") || []
    end
    
    def self.all_groups
      Global.read_config("demographics", "groups") || {}
    end
    
    def self.get_group(name)
      return nil if !name
      key = all_groups.keys.find { |g| g.downcase == name.downcase }
      return nil if !key
      return all_groups[key]
    end
    
    def self.census_types
      types = Demographics.all_groups.keys.map { |t| t.titlecase }
      types << 'Gender'
      types << 'Timezone'
      if (Ranks.is_enabled?)
        types << 'Rank'
      end
      types.sort
    end
    
    def self.census_by(&block)
      counts = {}
      Chargen.approved_chars.each do |c|
        val = yield(c)
        if (!val.blank?)
          count = counts.has_key?(val) ? counts[val] : 0
          counts[val] = count + 1
        end
      end
      counts.sort_by { |k,v| [0-v, k] }
    end
    
    def self.set_group(char, group_name, group)
      groups = char.groups
      groups[group_name.downcase] = group
      char.update(groups: groups)      
    end
    
  end
end
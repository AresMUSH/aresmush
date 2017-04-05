module AresMUSH
  module Groups

    def self.can_set_group?(char)
      char.has_permission?("set_group")
    end

    def self.all_groups
      Global.read_config("groups", "types")
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
    
    def self.app_review(char)
      message = t('groups.app_review')
      missing = []
      
      Groups.all_groups.keys.each do |g|
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
    
    def self.set_group(char, group_name, group_value)
      group = char.group(group_name)
      if (!group)
        GroupAssignment.create(character: char, group: group_name, value: group_value)
      else
        group.update(value: group_value)
      end
    end
  end
end

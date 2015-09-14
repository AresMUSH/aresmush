module AresMUSH
  module Groups

    def self.can_set_group?(char)
      char.has_any_role?(Global.read_config("groups", "roles", "can_set_group"))
    end

    def self.all_groups
      Global.read_config("groups", "types")
    end
    
    def self.get_group(name)
      return nil if name.nil?
      key = all_groups.keys.find { |g| g.downcase == name.downcase }
      return nil if key.nil?
      return all_groups[key]
    end
    
    def self.census_by(&block)
      counts = {}
      Character.active_chars.each do |c|
        next if c.idled_out
        val = yield(c)
        if (!val.nil?)
          count = counts.has_key?(val) ? counts[val] : 0
          counts[val] = count + 1
        end
      end
      counts = counts.sort_by { |k,v| v }.reverse
      counts.map { |k, v| "#{k.ljust(20)}#{v}"}
    end
  end
end

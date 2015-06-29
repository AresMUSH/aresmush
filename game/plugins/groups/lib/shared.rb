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
  end
end

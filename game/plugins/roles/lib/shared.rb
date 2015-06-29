module AresMUSH
  module Roles
    def self.all_roles
      Global.read_config("roles", "roles").map { |r| r.downcase }
    end
    
    def self.restricted_roles
      Global.read_config("roles", "restricted_roles").map { |r| r.downcase }
    end
    
    def self.can_assign_role?(actor)
      actor.has_any_role?(Global.read_config("roles", "can_assign_role"))
    end
    
    def self.is_restricted?(name)
      restricted_roles.include?(name.downcase)
    end
  end
end
module AresMUSH
  module Roles
    def self.all_roles
      Role.all.map { |r| r.name }
    end
    
    def self.restricted_roles
      Role.all.select { |r| r.is_restricted }.map { |r| r.name }
    end
    
    def self.can_assign_role?(actor)
      role = Global.read_config("roles", "can_assign_role")
      actor.has_any_role?(role)
    end
    
    def self.is_restricted?(name)
      role = Role.find_one(name: name)
      restricted_roles.include?(role)
    end
    
    def self.chars_with_role(name)
      role = Role.find_one(name: name)
      Character.all.select { |c| c.roles.include?(role) }
    end
  end
end
module AresMUSH
  module Roles
    def self.all_roles
      Roles.all.map { |r| r.name }
    end
    
    def self.restricted_roles
      Roles.all.select { |r| r.is_restricted }.map { |r| r.name }
    end
    
    def self.can_assign_role?(actor)
      actor.has_any_role?(Global.read_config("roles", "can_assign_role"))
    end
    
    def self.is_restricted?(name)
      role = Role.find(name: name).first
      restricted_roles.include?(role)
    end
    
    def self.valid_role?(name)
      role = Role.find(name: name).first
    end
    
    def self.chars_with_role(name)
      role = Role.find(name: name).first
      Character.select { |c| c.roles.include?(role) }
    end
  end
end
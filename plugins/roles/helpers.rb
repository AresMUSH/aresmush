module AresMUSH
  module Roles
    def self.all_roles
      Role.all.map { |r| r.name }
    end

    def self.restricted_roles
      Role.all.select { |r| r.is_restricted }.map { |r| r.name }
    end

    def self.can_assign_role?(actor)
      actor.is_admin?
    end

    def self.is_restricted?(name)
      role = Role.find_one_by_name(name)
      restricted_roles.include?(role)
    end

    def self.chars_with_role(name)
      role = Role.find_one_by_name(name)
      return [] if !role
      Character.all.select { |c| c.roles.include?(role) }
    end
  end
end

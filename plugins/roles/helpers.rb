module AresMUSH
  module Roles
    def self.all_roles
      Role.all.map { |r| r.name }
    end
    
    def self.restricted_roles
      Role.all.select { |r| r.is_restricted }.map { |r| r.name }
    end
    
    def self.can_assign_role?(actor)
      actor && actor.is_admin?
    end
    
    def self.is_restricted?(name)
      restricted_roles.map {|r| r.upcase }.include?(name.upcase)
    end
    
    def self.chars_with_role(name)
      role = Role.find_one_by_name(name)
      return [] if !role
      Character.all.select { |c| c.roles.include?(role) }
    end
    
    def self.admins_by_role
      admins = {}
      roles = Global.read_config("roles", "admin_list_roles")
      roles.each do |r|
        chars = Roles.chars_with_role(r)
        
        # Omit the special system chars.
        chars.delete Game.master.system_character
        chars.delete Game.master.master_admin
        admins[r] = chars
      end
      admins
    end
    
    def self.all_permissions
      permissions = []
      Global.config_reader.config.keys.each do |section|
        config = Global.read_config(section)
        if (config['permissions'])
          config['permissions'].each do |k, v|
            permissions << {
              section: section,
              name: k,
              description: v
            }
          end
        end
      end
      permissions
    end
  end
end
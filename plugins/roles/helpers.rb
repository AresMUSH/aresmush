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
    
    def self.save_web_roles(char, role_names, enactor)
      return t('dispatcher.not_allowed') if !Roles.can_assign_role?(enactor)
      
      existing_roles = char.roles.map { |r| r.name }
      delta_roles = existing_roles - role_names | role_names - existing_roles
      
      return if !delta_roles.any?
      
      delta_roles.each do |r|
        if (Roles.is_restricted?(r) && !enactor.is_master_admin?)
          return t('roles.role_restricted', :name => Game.master.master_admin.name) 
        end
      end
      
      Global.logger.info "#{enactor.name} changing roles for #{char.name}: #{role_names}"
      
      new_roles = []
      role_names.each do |r|
        role = Role.find_one_by_name(r)
        if (role)
          new_roles << role
        end
      end
      char.roles.replace new_roles
      return nil
    end
  end
end
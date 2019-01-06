module AresMUSH
  module Roles
    def self.all_staff
      chars = []
      roles = Global.read_config("roles", "admin_list_roles")
      roles.each do |r|
        chars.concat Roles.chars_with_role(r)
      end
      chars.delete Game.master.system_character
      chars.delete Game.master.master_admin
      chars
    end
    
    def self.add_role(char, role_name)
      role = Role.find_one_by_name(role_name)
      if (!role)
        return t('roles.role_does_not_exist')
      end
      
      if (char.has_role?(role_name))
        return t('roles.already_has_role', :name => char.name)
      end
    
      char.roles.add role
      Global.dispatcher.queue_event RoleChangedEvent.new(char, false)    
      return nil
    end
    
    def self.remove_role(char, role_name)
      role = Role.find_one_by_name(role_name)
      if (!role)
        return t('roles.role_does_not_exist')
      end
      
      if (!char.has_role?(role_name))
        return t('roles.doesnt_have_role', :name => char.name)
      end
    
      char.roles.delete role
      Global.dispatcher.queue_event RoleChangedEvent.new(char, true)    
      
      return nil
    end
  end
end
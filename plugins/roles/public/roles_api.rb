module AresMUSH
  module Roles
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
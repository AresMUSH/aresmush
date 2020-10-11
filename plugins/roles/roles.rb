$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Roles
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("roles", "shortcuts")
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "admin"
        case cmd.switch
        when nil
          # Check args because they might be trying to talk on the admin channel.
          if (!cmd.args)
            return AdminListCmd
          end
        when "position"
          return AdminPositionCmd
        end
      when "role"
        case cmd.switch
        when "assign"
          return RoleAssignCmd
        when "remove"
          return RoleRemoveCmd
        when "create"
          return RoleCreateCmd
        when "delete"
          return RoleDeleteCmd  
        when "addpermission", "removepermission"
          return RoleUpdatePermissionCmd        
        when nil
          return RolesCmd
        end
      when "permissions"
        return PermissionsCmd
      end
      
      nil
    end

    def self.get_event_handler(event_name) 
      case event_name
      when "CharCreatedEvent"
        return CharCreatedEventHandler
      end
      nil
    end
    
    def self.get_web_request_handler(request)
      case request.cmd
      when "admins"
        return AdminsRequestHandler
      when "roles"
        return RolesRequestHandler
      else
        return nil
      end
    end
    
    def self.check_config
      validator = RolesConfigValidator.new
      validator.validate
    end
  end
end

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
        if (!cmd.args)
          return AdminListCmd
        end
      when "adminnote"
        return AdminNoteCmd
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
  end
end

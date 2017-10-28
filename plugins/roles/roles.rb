$:.unshift File.dirname(__FILE__)
load "engine/admin_list_cmd.rb"
load "engine/admin_note_cmd.rb"
load "engine/char_created_event_handler.rb"
load "engine/roles_assign_cmd.rb"
load "engine/role_create_cmd.rb"
load "engine/role_delete_cmd.rb"
load "engine/roles_cmd.rb"
load "engine/role_update_permission_cmd.rb"
load "engine/roles_remove_cmd.rb"
load "engine/templates/admin_template.rb"
load "lib/roles_events.rb"
load "lib/roles_model.rb"
load "lib/helpers.rb"

module AresMUSH
  module Roles
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("roles", "shortcuts")
    end
 
    def self.load_plugin
      self
    end
 
    def self.unload_plugin
    end
 
    def self.config_files
      [ "config_roles.yml" ]
    end
 
    def self.locale_files
      [ "locales/locale_en.yml" ]
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
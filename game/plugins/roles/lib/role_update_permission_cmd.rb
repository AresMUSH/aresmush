module AresMUSH
  module Roles
    class RoleUpdatePermissionCmd
      include CommandHandler
      
      attr_accessor :name, :permission, :remove_permission
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = trim_arg(args.arg1)
        self.permission = trim_arg(args.arg2)
        self.remove_permission = cmd.switch_is?("removepermission")
      end
      
      def required_args
        {
          args: [ self.name, self.permission ],
          help: 'roles manage'
        }
      end
      
      def check_can_assign_role
        return t('dispatcher.not_allowed') if !Roles.can_assign_role?(enactor)
        return nil
      end
      
      def handle  
        role = Role.find_one_by_name(self.name)
        
        if (!role)
          client.emit_failure t('roles.role_does_not_exist')
          return
        end
        
        permissions = role.permissions
        if (self.remove_permission)
          permissions.delete(self.permission)
        else
          permissions << self.permission
        end
        
        role.update(permissions: permissions)
        client.emit_success t('roles.role_permissions_updated')
      end
    end
  end
end

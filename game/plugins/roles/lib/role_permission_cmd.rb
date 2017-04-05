module AresMUSH
  module Roles
    class RolePermissionCmd
      include CommandHandler
      
      attr_accessor :name, :permission, :remove_permission
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = trim_arg(args.arg1)
        self.permission = trim_arg(args.arg2)
        
        if (self.permission)
          self.permission = self.permission.downcase
          if self.permission.start_with?("!")
            self.permission = self.permission.after("!")
            self.remove_permission = true
          end
        else
          self.remove_permission = false
        end
      end
      
      def required_args
        {
          args: [ self.name, self.permission ],
          help: 'roles'
        }
      end
      
      def check_can_assign_role
        return t('dispatcher.not_allowed') if !Roles.can_assign_role?(enactor)
        return nil
      end
      
      def check_role_exists
        return t('roles.role_does_not_exist') if !Role.found?(self.name)
        return nil
      end
      
      def handle  
        role = Role.find_one_by_name(self.name)
        permissions = role.permissions
        if (remove_permission)
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

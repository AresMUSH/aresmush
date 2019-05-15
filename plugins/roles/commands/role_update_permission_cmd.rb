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
        [ self.name, self.permission ]
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

        if (self.remove_permission)
          permissions = role.permissions
          permissions.delete(self.permission)
          role.update(permissions: permissions)
          client.emit_success t('roles.role_permissions_updated')          
        else
          if Permissions.is_permission?(self.permission)
            role.add_permission self.permission
            client.emit_success t('roles.role_permissions_updated')
          else
            client.emit_failure t('permissions.invald_permission', :perms => self.permission)
          end
        end


      end
    end
  end
end

module AresMUSH
  module Roles
    class RoleUpdatePermissionCmd
      include CommandHandler
      
      attr_accessor :name, :permission, :remove_permission
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = trim_arg(args.arg1)
        self.permission = downcase_arg(args.arg2)
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
        
        if (self.permission =~ /[, ]/)
          client.emit_failure t('roles.permissions_no_spaces')
          return
        end
        
        if (!Roles.all_permissions.any? { |p| p[:name].downcase == self.permission })
          # Warn but continue - might be part of a custom plugin.
          client.emit_failure t('roles.unrecognized_permission', :name => self.permission)
        end
        
        if (self.remove_permission)
          permissions = role.permissions
          permissions.delete(self.permission)
          role.update(permissions: permissions)
        else
          role.add_permission self.permission
        end
        
        client.emit_success t('roles.role_permissions_updated')
      end
    end
  end
end

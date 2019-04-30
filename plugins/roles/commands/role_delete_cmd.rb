module AresMUSH
  module Roles
    class RoleDeleteCmd
      include CommandHandler
      
      attr_accessor :name
      
      def parse_args
        self.name = cmd.args ? trim_arg(cmd.args).downcase : nil
      end
      
      def required_args
        [ self.name ]
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
        role.delete
        client.emit_success t('roles.role_deleted', :name => self.name)
      end
    end
  end
end

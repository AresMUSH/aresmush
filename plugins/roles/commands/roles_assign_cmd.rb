module AresMUSH
  module Roles
    class RoleAssignCmd
      include CommandHandler
      
      attr_accessor :name
      attr_accessor :role
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = trim_arg(args.arg1)
        self.role = trim_arg(args.arg2)
      end
      
      def required_args
        [ self.name, self.role ]
      end
      
      def check_can_assign_role
        return t('dispatcher.not_allowed') if !Roles.can_assign_role?(enactor)
        return t('roles.role_restricted', :name => Game.master.master_admin.name) if (Roles.is_restricted?(self.role) && !enactor.is_master_admin?)
        return nil
      end
      
      def check_role_exists
        return t('roles.role_does_not_exist') if !Role.found?(self.role)
        return nil
      end
      
      def handle  
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |char|
          error = Roles.add_role(char, self.role)
          if (error)
            client.emit_failure error
          else
            Global.logger.info "#{enactor_name} added role #{self.role} to #{char.name}."     
            client.emit_success t('roles.role_assigned', :name => char.name, :role => self.role.downcase)
          end
        end
      end
    end
  end
end

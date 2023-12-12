module AresMUSH
  module Roles
    class RoleInfoCmd
      include CommandHandler
                
      attr_accessor :name
      
      def parse_args
        self.name = trim_arg(cmd.args)
      end
      
      def required_args
        [ self.name ]
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
           
        template = RoleInfoTemplate.new(role, Roles.all_permissions)
        client.emit template.render
      end
    end
  end
end

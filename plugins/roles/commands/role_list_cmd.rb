module AresMUSH
  module Roles
    class RoleListCmd
      include CommandHandler

      def check_can_assign_role
        return t('dispatcher.not_allowed') if !Roles.can_assign_role?(enactor)
        return nil
      end
                      
      def handle        
        roles = Role.all
        template = RolesListTemplate.new(roles)
        client.emit template.render
      end
    end
  end
end

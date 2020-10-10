module AresMUSH
  module Roles
    class PermissionsCmd
      include CommandHandler
                
      def handle        
        permissions = Roles.all_permissions          
        template = PermissionsTemplate.new(permissions)
        client.emit template.render
      end
    end
  end
end

module AresMUSH
  module Permissions
    class PermissionsListCmd
      include CommandHandler
      def handle
        permissions = Permissions.permissions
        template = PermissionPageTemplate.new permissions
        client.emit template.render
      end
    end
  end
end

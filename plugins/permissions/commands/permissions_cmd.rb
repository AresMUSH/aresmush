module AresMUSH
  module Permissions
    class PermissionsListCmd
      include CommandHandler
      def handle
        template = PermissionPageTemplate.new("/permissions.erb",
            { permissions: Permissions.permissions})
        client.emit template.render
      end
    end
  end
end

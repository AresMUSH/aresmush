module AresMUSH
  module Permissions
    class PermissionsListCmd
      include CommandHandler
      def handle
        PermissionPageTemplate.new("/permissions.erb", Permissions.permissions)
        client.emit template.render
      end
    end
  end
end

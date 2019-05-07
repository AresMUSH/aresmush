module AresMUSH
  module Permissions
    class PermissionsListCmd
      include CommandHandler
      def handle
        PermissionPageTemplate.new("/attributes.erb", Permissions.permissions.sort)
        client.emit template.render
      end
    end
  end
end

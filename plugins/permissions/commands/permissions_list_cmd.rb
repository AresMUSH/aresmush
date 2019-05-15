module AresMUSH
  module Permissions
    class PermissionsListCmd
      include CommandHandler
      def handle

        num_pages = 1

        case cmd.page
        when 1
          template = PermissionPageTemplate.new("/permissions.erb",
              { permissions: Permissions.permissions, num_pages: num_pages, page: cmd.page })
        else
          client.emit_failure t('pages.not_that_many_pages')
            return
       end
      client.emit template.render
      end
    end
  end
end

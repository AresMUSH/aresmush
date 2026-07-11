module AresMUSH
  module Roles
    class AdminsRequestHandler
      def handle(request)
        admins = Roles.admins_by_role
        
        admins.map { |role, chars| {
          name: role.titleize,
          chars: chars.map { |c| {
            name: c.name,
            id: c.id,
            avatar: Website.avatar_info(c),
            title: c.role_admin_note
          }}
        }}
      end
    end
  end
end
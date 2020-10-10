module AresMUSH
  module Roles
    class RolesRequestHandler
      def handle(request)
        enactor = request.enactor

        error = Website.check_login(request, true)
        return error if error
        
        is_admin = enactor && enactor.is_admin?
        roles = Role.all.to_a.sort_by { |r| r.name }.map { |r| 
          {
            name: r.name,
            permissions: r.permissions,
            chars: is_admin ? 
               Character.all.select { |c| c.has_role?(r) }.map { |c| c.name }.sort : 
               nil
          }
        }
        
        {
          roles: roles,
          permissions: Roles.all_permissions.sort_by { |p| p[:name] }
        }
        
      end
    end
  end
end
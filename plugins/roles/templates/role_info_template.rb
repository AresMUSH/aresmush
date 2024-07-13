module AresMUSH
  module Roles
    class RoleInfoTemplate < ErbTemplateRenderer
      
      attr_accessor :role, :permissions

      def initialize(role, permissions)
        @role = role
        @permissions = permissions
        super File.dirname(__FILE__) + "/role_info.erb"
      end
            
      def permission_desc(name)
        permission = @permissions.select { |p| p[:name] == name }.first
        if (permission)
          return permission[:description]
        else
          return ""
        end
      end
      
      def players()
        if (@role.name == "everyone")
          "EVERYONE"
        else
          Character.all.select { |c| c.has_role?(@role) }.sort_by { |c| c.name }.map { |c| c.name }.join(" ")
        end
      end
    end
  end
end
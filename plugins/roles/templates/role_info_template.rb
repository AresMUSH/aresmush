module AresMUSH
  module Roles
    class RoleInfoTemplate < ErbTemplateRenderer
      
      attr_accessor :role

      def initialize(role)
        @role = role
        super File.dirname(__FILE__) + "/role_info.erb"
      end
      
      def permissions()
        if (@role.name == "admin") 
          "ALL"
        else
          @role.permissions.join(" ")
        end
      end
      
      def players()
        if (@role.name == "everyone")
          "EVERYONE"
        else
          Character.all.select { |c| c.has_role?(@role) }.map { |c| c.name }.join(" ")
        end
      end
    end
  end
end
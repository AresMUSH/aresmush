module AresMUSH
  module Roles
    class RolesListTemplate < ErbTemplateRenderer
      
      attr_accessor :roles

      def initialize(roles)
        @roles = roles
        super File.dirname(__FILE__) + "/roles_list.erb"
      end
      
      def permissions(role)
        if (role.name == "admin") 
          "ALL"
        else
          role.permissions.join(" ")
        end
      end      
    end
  end
end
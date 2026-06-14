module AresMUSH
  module Roles
    class RolesForCharTemplate < ErbTemplateRenderer
      
      attr_accessor :char

      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/roles_for_char.erb"
      end
      
      def has_role(role)
        @char.has_role?(role) ? '(%xh%xg+%xn)' : '( )'        
      end
      
      def permissions(role)
        list = (role.permissions || []).join(', ')
        admin_note = role.name == "admin" ? "%xh%xr**%xn " : ""
        "#{admin_note}#{list}"
      end
    end
  end
end
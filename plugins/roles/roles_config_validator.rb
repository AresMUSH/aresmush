module AresMUSH
  module Roles
    class RolesConfigValidator
      attr_accessor :validator
      
      def initialize
        @validator = Manage::ConfigValidator.new("roles")
      end
      
      def validate
        @validator.require_list('admin_list_roles')
        @validator.require_list('default_roles')
        @validator.require_list('restricted_roles')
        
        begin
          @validator.check_roles_exist('admin_list_roles')
          @validator.check_roles_exist('default_roles')
          @validator.check_roles_exist('restricted_roles')
        rescue Exception => ex
          @validator.add_error "Unknown roles config error.  Fix other errors first and try again. #{ex} #{ex.backtrace[0, 3]}"
        end
        
        @validator.errors
      end

    end
  end
end
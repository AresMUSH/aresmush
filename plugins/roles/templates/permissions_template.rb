module AresMUSH
  module Roles
    class PermissionsTemplate < ErbTemplateRenderer
      
      attr_accessor :permissions

      def initialize(permissions)
        @permissions = permissions.sort_by { |p| p[:name] }
        super File.dirname(__FILE__) + "/permissions.erb"
      end
    end
  end
end
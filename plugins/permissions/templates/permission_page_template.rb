module AresMUSH
  module Permissions
    class PermissionPageTemplate < ErbTemplateRenderer


      attr_accessor :data

      def initialize(file, data)
        @data = data
        super File.dirname(__FILE__) + file
      end

            
    end
  end
end

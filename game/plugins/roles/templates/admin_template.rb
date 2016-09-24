module AresMUSH
  module Roles
    class AdminTemplate < ErbTemplateRenderer
      include TemplateFormatters
      
      attr_accessor :admins_by_role

      def initialize(admins_by_role)
        @admins_by_role = admins_by_role
        super File.dirname(__FILE__) + "/admin.erb"
      end
      
      def note(a)
        a.admin_note || "."
      end
      
      def status(a)
        if (a.client)
          connected = Status::Api.is_on_duty?(a) ? t('roles.connected_on_duty') : t('roles.connected_off_duty')
        else
          connected = t('roles.offline')
        end
        return connected
      end
    end
  end
end
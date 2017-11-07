module AresMUSH
  module Roles
    class AdminTemplate < ErbTemplateRenderer
      
      attr_accessor :admins_by_role

      def initialize(admins_by_role)
        @admins_by_role = admins_by_role
        super File.dirname(__FILE__) + "/admin.erb"
      end
      
      def note(a)
        a.role_admin_note || "."
      end
      
      def status(a)
        if (Login.is_online?(a))
          connected = a.is_on_duty? ? t('roles.connected_on_duty') : t('roles.connected_off_duty')
        else
          connected = t('roles.offline')
        end
        return connected
      end
    end
  end
end
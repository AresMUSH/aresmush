module AresMUSH
  module Roles
    class AdminTemplate < AsyncTemplateRenderer
      include TemplateFormatters
      
      def initialize(admins_by_role, client)
        @admins_by_role = admins_by_role
        super client
      end
      
      def build
        text = ""
        @admins_by_role.each do |role, chars|
          if (!text.blank?)
            text << "%R%R"
          end
          text << "%xh#{role.titleize}%xn"
          chars.sort_by { |r| r.name }.each do |c|
            next if (Game.master.is_special_char?(c))
            text << "%R#{left(c.name,35)}#{admin_status(c)}"
          end
        end
        BorderedDisplay.text text, t('roles.game_admin')        
      end
      
      def admin_status(a)
        if (a.client)
          connected = a.is_on_duty? ? t('roles.connected_on_duty') : t('roles.connected_off_duty')
        else
          connected = t('roles.last_on', :last_on => OOCTime.local_long_timestr(self.client, a.last_on))
        end
        return connected
      end
    end
  end
end
module AresMUSH
  module Roles
    class AdminListCmd
      include Plugin
      include PluginWithoutSwitches
      include TemplateFormatters
            
      def want_command?(client, cmd)
        cmd.root_is?("admin")
      end
      
      def handle
        text = ""
        Global.config["roles"]["game_admin"].each do |role|
          if (!text.blank?)
            text << "%R%R"
          end
          text << "%xh#{role.titleize}%xn"
          Roles.chars_with_role(role).sort_by { |r| r.name }.each do |c|
            next if (Game.master.is_special_char?(c))
            text << "%R#{left(c.name,35)}#{admin_status(c)}"
          end
        end
            
        client.emit BorderedDisplay.text text, t('roles.game_admin')
      end

      def admin_status(a)
        if (a.client)
          connected = a.is_on_duty? ? t('roles.connected_on_duty') : t('roles.connected_off_duty')
        else
          connected = t('roles.last_on', :last_on => OOCTime.local_long_timestr(client, a.last_on))
        end
        return connected
      end
    end
  end
end

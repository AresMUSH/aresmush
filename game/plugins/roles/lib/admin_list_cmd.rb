module AresMUSH
  module Utils
    class AdminListCmd
      include Plugin
      include PluginWithoutSwitches
            
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
            text << "%R#{c.name}"
          end
        end
            
        client.emit BorderedDisplay.text text, t('roles.game_admin')
      end
    end
  end
end

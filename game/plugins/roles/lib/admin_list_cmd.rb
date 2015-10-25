module AresMUSH
  module Roles
    class AdminListCmd
      include Plugin
      include TemplateFormatters
      include PluginWithoutSwitches
            
      def want_command?(client, cmd)
        cmd.root_is?("admin") && !cmd.args
      end
      
      def handle
        admins_by_role = {}
        roles = Global.read_config("roles", "game_admin")
        roles.each do |r|
          admins_by_role[r] = Roles.chars_with_role(r)
        end
        template = AdminTemplate.new(admins_by_role, client)
        template.render
      end
    end
  end
end

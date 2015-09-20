module AresMUSH
  module FS3Combat
    class WeaponsListCmd
      include Plugin
      include PluginRequiresLogin
      include TemplateFormatters
      
      def want_command?(client, cmd)
        cmd.root_is?("weapon") && !cmd.args
      end
      
      def handle
        template = GearTemplate.new FS3Combat.weapons, t('fs3combat.weapons_title'), client
        template.render
      end
    end
  end
end
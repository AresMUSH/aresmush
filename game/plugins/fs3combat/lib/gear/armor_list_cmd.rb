module AresMUSH
  module FS3Combat
    class ArmorListCmd
      include CommandHandler
      include CommandRequiresLogin
      include TemplateFormatters
      
      def want_command?(client, cmd)
        cmd.root_is?("armor") && !cmd.args
      end
      
      def handle
        template = GearTemplate.new FS3Combat.armors, t('fs3combat.armor_title'), client
        template.render
      end
      
    end
  end
end
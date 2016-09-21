module AresMUSH
  module FS3Combat
    class WeaponsListCmd
      include CommandHandler
      include CommandRequiresLogin
      include TemplateFormatters      
      
      def handle
        template = GearTemplate.new FS3Combat.weapons, t('fs3combat.weapons_title'), client
        template.render
      end
    end
  end
end
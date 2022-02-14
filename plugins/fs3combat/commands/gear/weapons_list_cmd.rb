module AresMUSH
  module FS3Combat
    class WeaponsListCmd
      include CommandHandler
      include TemplateFormatters      
      
      def handle
        template = GearListTemplate.new FS3Combat.weapons, t('fs3combat.weapons_title')
        client.emit template.render
      end
    end
  end
end
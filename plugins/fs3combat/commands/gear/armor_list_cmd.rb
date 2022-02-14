module AresMUSH
  module FS3Combat
    class ArmorListCmd
      include CommandHandler
      
      def handle
        template = GearListTemplate.new FS3Combat.armors, t('fs3combat.armor_title')
        client.emit template.render
      end
      
    end
  end
end
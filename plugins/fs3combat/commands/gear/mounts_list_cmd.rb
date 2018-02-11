module AresMUSH
  module FS3Combat
    class MountsListCmd
      include CommandHandler
      
      def check_mounts_allowed
        return t('fs3combat.mounts_disabled') if !FS3Combat.mounts_allowed?
        return nil
      end
      
      def handle
        template = GearListTemplate.new FS3Combat.mounts, t('fs3combat.mounts_title')
        client.emit template.render
      end
    end
  end
end
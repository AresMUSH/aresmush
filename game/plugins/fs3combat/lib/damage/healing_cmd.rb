module AresMUSH
  module FS3Combat
    class HealingCmd
      include CommandHandler
      include CommandRequiresLogin
      
      def handle
        template = HealingTemplate.new(enactor)
        client.emit template.render
      end
    end
  end
end
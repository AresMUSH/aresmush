module AresMUSH

  module FS3XP
    class XpCostsCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
      
      def handle
        template = XpTemplate.new
        client.emit template.render
      end
    end
  end
end

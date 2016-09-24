module AresMUSH
  module Bbs
    class BbsListCmd
      include CommandHandler
      include CommandRequiresLogin      
      
      def handle       
        template = BoardListTemplate.new(client.char) 
        client.emit template.render
      end
    end
  end
end

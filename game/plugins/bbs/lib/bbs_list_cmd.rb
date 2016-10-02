module AresMUSH
  module Bbs
    class BbsListCmd
      include CommandHandler
      include CommandRequiresLogin      
      
      def handle       
        template = BoardListTemplate.new(enactor) 
        client.emit template.render
      end
    end
  end
end

module AresMUSH
  module Bbs
    class BbsListCmd
      include CommandHandler
      
      def help
        "`bbs <board name or number>/<post #>` - Reads the selected post.%R" + 
        "`bbs` - Lists available boards."
      end
      
      def handle       
        template = BoardListTemplate.new(enactor) 
        client.emit template.render
      end
    end
  end
end

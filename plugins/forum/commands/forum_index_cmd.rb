module AresMUSH
  module Forum
    class ForumIndexCmd
      include CommandHandler
      
      def handle       
        template = ForumIndexTemplate.new(enactor) 
        client.emit template.render
      end
    end
  end
end

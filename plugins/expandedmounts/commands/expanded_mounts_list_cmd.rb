module AresMUSH
  module ExpandedMounts
    class ExpandedMountsListCmd
      include CommandHandler
      
      def handle
        template = ExpandedMountsListTemplate.new 
        client.emit template.render
      end
      
    end
  end
end
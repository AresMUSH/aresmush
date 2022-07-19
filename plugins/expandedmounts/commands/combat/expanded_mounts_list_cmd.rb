module AresMUSH
  module ExpandedMounts
    class MountsListCmd
      include CommandHandler
      
      def handle
        template = MountsListTemplate.new 
        client.emit template.render
      end
      
    end
  end
end
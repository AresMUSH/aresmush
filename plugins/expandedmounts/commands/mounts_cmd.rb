module AresMUSH
  module ExpandedMounts
    class ExpandedMountsCmd
      include CommandHandler
      
      def handle
        template = ExpandedMountsTemplate.new
        client.emit template.render
      end
    end
  end
end
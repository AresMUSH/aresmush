module AresMUSH
  module ExpandedMounts
    class ExpandedMountsListAllCmd
      include CommandHandler

      def handle
        template = ExpandedMountsListAllTemplate.new
        client.emit template.render
      end

    end
  end
end
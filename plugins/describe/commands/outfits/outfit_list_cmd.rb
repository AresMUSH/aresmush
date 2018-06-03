module AresMUSH
  module Describe
    class OutfitListCmd
      include CommandHandler
      
      def handle
        outfits = enactor.outfits.keys
        template = BorderedListTemplate.new outfits, t('describe.your_outfits')
        client.emit template.render
      end
    end
  end
end

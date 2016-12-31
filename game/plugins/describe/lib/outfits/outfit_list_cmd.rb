module AresMUSH
  module Describe
    class OutfitListCmd
      include CommandHandler
      
      def handle
        outfits = enactor.outfits.map { |d| d.name }
        client.emit BorderedDisplay.list(outfits, t('describe.your_outfits'))
      end
    end
  end
end

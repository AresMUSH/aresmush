module AresMUSH
  module Describe
    class OutfitListCmd
      include CommandHandler
      include CommandRequiresLogin
      
      def handle
        client.emit BorderedDisplay.list(client.char.outfits.keys, t('describe.your_outfits'))
      end
    end
  end
end

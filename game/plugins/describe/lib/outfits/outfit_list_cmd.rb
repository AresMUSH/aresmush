module AresMUSH
  module Describe
    class OutfitListCmd
      include CommandHandler
      include CommandRequiresLogin
      
      def handle
        client.emit BorderedDisplay.list(enactor.outfits.keys, t('describe.your_outfits'))
      end
    end
  end
end

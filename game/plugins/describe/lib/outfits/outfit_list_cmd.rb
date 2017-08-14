module AresMUSH
  module Describe
    class OutfitListCmd
      include CommandHandler
      
      def help
        "`outfits` - Lists outfits\n" + 
        "`outfit <name>` - Views an outfit."
      end

      def handle
        outfits = enactor.outfits.map { |d| d.name }
        template = BorderedListTemplate.new outfits, t('describe.your_outfits')
        client.emit template.render
      end
    end
  end
end

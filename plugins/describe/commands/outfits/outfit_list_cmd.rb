module AresMUSH
  module Describe
    class OutfitListCmd
      include CommandHandler
      
      def handle
        if (cmd.switch_is?("all"))
          outfits = enactor.outfits.map { |k, v| "#{k}: #{v}"}
        else
          outfits = enactor.outfits.keys
        end
        template = BorderedListTemplate.new outfits, t('describe.your_outfits')
        client.emit template.render
      end
    end
  end
end

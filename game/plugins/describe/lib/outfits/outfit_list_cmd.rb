module AresMUSH
  module Describe
    class OutfitListCmd
      include CommandHandler
      include CommandRequiresLogin
      
      def want_command?(client, cmd)
        cmd.root_is?("outfit") && cmd.switch.nil? && cmd.args.nil?
      end
      
      def handle
        client.emit BorderedDisplay.list(client.char.outfits.keys, t('describe.your_outfits'))
      end
    end
  end
end

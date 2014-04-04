module AresMUSH
  module Describe
    class OutfitListCmd
      include Plugin
      include PluginRequiresLogin
      
      def want_command?(client, cmd)
        (cmd.root_is?("outfit") || cmd.root_is?("outfits")) && cmd.switch.nil? && cmd.args.nil?
      end
      
      def handle
        client.emit BorderedDisplay.list(client.char.outfits.keys, t('describe.your_outfits'))
      end
    end
  end
end

module AresMUSH
  module Chargen
    class ChargenStartCmd
      include CommandHandler
      include CommandRequiresLogin

      def handle
        client.char.chargen_stage = 0
        client.char.save!

        client.emit BorderedDisplay.text Chargen.chargen_display(client.char)
      end
    end
  end
end

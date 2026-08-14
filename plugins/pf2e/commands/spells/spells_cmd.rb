module AresMUSH
  module Pf2e
    class SpellsCmd
      include CommandHandler

      def handle
        client.emit Pf2e.format_magic_status(enactor)
      end
    end
  end
end

module AresMUSH
  module Chargen
    class ChargenStartCmd
      include CommandHandler
      include CommandRequiresLogin

      def handle
        client.char.chargen_stage = 0
        client.char.save!

        template = ChargenTemplate.new(client.char)
        client.emit template.render
      end
    end
  end
end

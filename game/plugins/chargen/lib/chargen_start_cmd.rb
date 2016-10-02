module AresMUSH
  module Chargen
    class ChargenStartCmd
      include CommandHandler
      include CommandRequiresLogin

      def handle
        enactor.chargen_stage = 0
        enactor.save

        template = ChargenTemplate.new(enactor)
        client.emit template.render
      end
    end
  end
end

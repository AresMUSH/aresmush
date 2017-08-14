module AresMUSH
  module Chargen
    class ChargenStartCmd
      include CommandHandler

      def help
        "`chargen/start` - Starts chargen."
      end
      
      def handle
        enactor.update(chargen_stage: 0)

        template = ChargenTemplate.new(enactor)
        client.emit template.render
      end
    end
  end
end

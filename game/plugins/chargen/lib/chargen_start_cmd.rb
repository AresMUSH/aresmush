module AresMUSH
  module Chargen
    class ChargenStartCmd
      include CommandHandler
      include CommandRequiresLogin

      def handle
        chargen_info = enactor.chargen_info
        if (!chargen_info)
          chargen_info = ChargenInfo.create(character: enactor)
          enactor.chargen_info = chargen_info
          enactor.save
        end
        
        chargen_info.current_stage = 0
        chargen_info.save

        template = ChargenTemplate.new(enactor)
        client.emit template.render
      end
    end
  end
end

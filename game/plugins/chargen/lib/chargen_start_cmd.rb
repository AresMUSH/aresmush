module AresMUSH
  module Chargen
    class ChargenStartCmd
      include CommandHandler
      include CommandRequiresLogin

      def handle
        chargen_info = enactor.get_or_create_chargen_info
        chargen_info.update(current_stage: 0)

        template = ChargenTemplate.new(enactor)
        client.emit template.render
      end
    end
  end
end

module AresMUSH
  module Describe
    class GlanceCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      include CommandWithoutArgs
      
      def handle
        template = GlanceTemplate.new(enactor_room)
        client.emit template.render
      end        
    end
  end
end

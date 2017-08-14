module AresMUSH
  module Describe
    class GlanceCmd
      include CommandHandler
      
      def help
        "`glance` - Shows the short descriptions of everyone in the room."
      end
      
      def handle
        template = GlanceTemplate.new(enactor_room)
        client.emit template.render
      end        
    end
  end
end

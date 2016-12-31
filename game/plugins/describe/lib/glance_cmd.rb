module AresMUSH
  module Describe
    class GlanceCmd
      include CommandHandler
      
      def handle
        template = GlanceTemplate.new(enactor_room)
        client.emit template.render
      end        
    end
  end
end

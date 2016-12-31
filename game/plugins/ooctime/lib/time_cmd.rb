module AresMUSH
  module OOCTime
    class TimeCmd
      include CommandHandler
           
      def handle
        template = TimeTemplate.new(enactor)
        client.emit template.render
      end
    end
  end
end

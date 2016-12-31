module AresMUSH
  module OOCTime
    class TimeCmd
      include CommandHandler
      include CommandWithoutArgs
           
      def handle
        template = TimeTemplate.new(enactor)
        client.emit template.render
      end
    end
  end
end

module AresMUSH
  module OOCTime
    class TimeCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutSwitches
      include CommandWithoutArgs
           
      def handle
        template = TimeTemplate.new(enactor)
        client.emit template.render
      end
    end
  end
end

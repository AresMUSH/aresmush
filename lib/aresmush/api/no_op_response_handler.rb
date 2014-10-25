module AresMUSH
  module Api
    class NoOpResponseHandler
      include ApiResponseHandler
      
      def self.commands
        ["n/a"]
      end
      
      def handle   
        Global.logger.debug "#{response} response received."
      end
    end
  end
end
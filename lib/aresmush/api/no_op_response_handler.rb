module AresMUSH
  module Api
    class NoOpResponseHandler
      include ApiResponseHandler
      
      def handle   
        Global.logger.debug "#{response} response received."
      end
    end
  end
end
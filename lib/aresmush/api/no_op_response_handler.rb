module AresMUSH
  module Api
    class NoOpResponseHandler < ApiResponseHandler
      def handle   
        Global.logger.debug "#{response} response received."
      end
    end
  end
end
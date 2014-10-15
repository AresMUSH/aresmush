module AresMUSH
  module Api
    class PingResponseHandler < ApiResponseHandler
      def handle   
        Global.logger.debug "Ping successful."
      end
    end
  end
end
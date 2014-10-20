module AresMUSH
  module Api
    class UnlinkResponseHandler < ApiResponseHandler
      def handle   
        Global.logger.debug "Unlink successful."
      end
    end
  end
end
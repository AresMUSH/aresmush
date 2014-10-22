module AresMUSH
  module Api
    class NoOpResponseHandler < ApiResponseHandler
      def handle   
        Global.logger.debug "#{response.command_name} successful."
      end
    end
  end
end
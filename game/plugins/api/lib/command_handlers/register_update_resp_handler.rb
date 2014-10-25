module AresMUSH
  module Api
    class RegisterUpdateResponseHandler
      include ApiResponseHandler
      
      def handle   
        Global.logger.info "Game registration successfully updated."
      end
    end
  end
end
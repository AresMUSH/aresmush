module AresMUSH
  module Api
    class RegisterUpdateResponseHandler
      def self.handle(response)
        if (response.is_ok?)
          Global.logger.info "Game information successfully updated."
        else
          Global.logger.error "Game information not updated: #{response.error}."
        end
      end
    end
  end
end
module AresMUSH
  module Api
    class ApiRegisterResponseHandlerMaster
      def self.handle(response)
        if (response.raw == "OK")
          Global.logger.info "Game information successfully updated."
        else
          Global.logger.error "Game information not updated: #{response.raw}."
        end
      end
    end
  end
end
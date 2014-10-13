module AresMUSH
  module Api
    class RegisterUpdateResponseHandler
      attr_accessor :response, :client
      
      def initialize(client, response)
        @client = client
        @response = response
      end
      
      def handle   
        if (@response.is_success?)
          Global.logger.info "Game registration successfully updated."
        else
          raise "There was a problem updating your game registration: #{response.args}."
        end
      end
    end
  end
end
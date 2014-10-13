module AresMUSH
  module Api
    class ApiResponseHandler
      include Plugin
      
      def on_api_response_event(event)
        Api.router.route_response(event.client, event.response)
      end
    end
  end
end

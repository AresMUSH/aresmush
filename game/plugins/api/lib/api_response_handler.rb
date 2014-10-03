module AresMUSH
  module Api
    class ApiResponseHandler
      include Plugin
      
      def on_api_response_event(event)
        client = event.client
        response = event.response
        error = event.error
        
        Global.logger.debug "API Response: #{response} #{error}"
        
        response_str = response.after("api< ")
        
        if (error)
          if (client)
            client.emit_failure error
          end
          return
        end
        Api.router.route_response(client, response_str)
      end
    end
  end
end
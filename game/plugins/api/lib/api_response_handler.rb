module AresMUSH
  module Api
    class ApiResponseHandler
      include Plugin
      
      def on_api_response_event(event)
        client = event.client
        response = event.response
        error = event.error
        
        Global.logger.debug "Handling API Response: #{response} #{error}"

        AresMUSH.with_error_handling(nil, "Handling API Response #{response}") do
          if (error)
            if (client)
              client.emit_failure error
            end
            return
          end
          response_str = response.after("api< ")
          Api.router.route_response(client, response_str)
        end
      end
    end
  end
end
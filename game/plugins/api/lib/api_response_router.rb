module AresMUSH
  module Api
    class ApiResponseRouter
      include CommandHandler
      
      def on_api_response_event(event)
        client = event.client
        response = event.response
        if (!response.is_success?)
          message = "API response error: #{response}.  If you are having trouble communicating with AresCentral, visit aresmush.com for help."
          Global.logger.info message
          if (client)
            client.emit_failure "Error processing remote request: #{response.args_str}"
          else
            Global.dispatcher.queue_event UnhandledErrorEvent.new(message)
          end
          return
        else
          Global.api_router.route_response(client, response)
        end
      end
    end
  end
end

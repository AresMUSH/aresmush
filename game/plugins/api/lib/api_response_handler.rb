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
        command = response_str.before(" ")
        args = response_str.after(" ")
        
        case command
        when "register"
          resp = ApiRegisterResponse.new(client, args)
          ApiRegisterResponseHandler.handle(resp)
        else
          return "Unrecognized command #{command}."
        end
      end
    end
  end
end
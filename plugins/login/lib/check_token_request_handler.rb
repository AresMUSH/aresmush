module AresMUSH
  module Login
    class CheckTokenRequestHandler
      def handle(request)
                
        id = request.args[:id]
        token = request.args[:token]
        
        char = Character.find_one_by_name(id)
        if (!char)
          return { error: "Character not found." }
        end
        
        if (char.is_valid_api_token?(token))
          return { tokenIsValid: true }
        end
        
        { error: "Your session has expired.  Please log in again." }        
      end
    end
  end
end
module AresMUSH
  module Website
    class GetConfigRequestHandler
      def handle(request)
        topic = request.args[:topic]
        enactor = request.enactor
        
        error = WebHelpers.check_login(request)
        return error if error
        
        if (enactor.is_admin?)
          return { error: "You are not an admin." }
        end
        
        if (topic)
          Global.read_config(topic)
        else
          Global.config.keys
        end
      end
    end
  end
end
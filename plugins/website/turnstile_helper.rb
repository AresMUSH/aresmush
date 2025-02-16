module AresMUSH
  module Website
    class TurnstileHelper
  
      def site_key
        Global.read_config("secrets", "turnstile", "site_key")
      end

      def secret
        Global.read_config("secrets", "turnstile", "secret")
      end
  
      def is_enabled?
        !site_key.blank? && !secret.blank?
      end
  
      def verify(response)
        if (!is_enabled?)
          Global.logger.warn "Tried to use Turnstile but it isn't enabled."
          return true
        end
    
        connector = RestConnector.new('https://challenges.cloudflare.com/turnstile/v0')
        body = {
          secret: self.secret,
          response: response
        }
        
        
        result = connector.post('siteverify', body)
        
        Global.logger.debug(result);
        Global.logger.debug(result["success"]);
          
        result["success"] == true ? true : false    
      end
    end
  end
end
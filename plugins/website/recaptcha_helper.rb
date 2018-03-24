module AresMUSH
  module Website
    class RecaptchaHelper
  
      def site_key
        Global.read_config("secrets", "recaptcha", "site_key")
      end

      def secret
        Global.read_config("secrets", "recaptcha", "secret")
      end
  
      def is_enabled?
        !site_key.blank? && !secret.blank?
      end
  
      def verify(response)
        if (!is_enabled?)
          Global.logger.warn "Tried to use recaptcha but it isn't enabled."
          return true
        end
    
        status = `curl "https://www.google.com/recaptcha/api/siteverify?secret=#{secret}&response=#{response}"`
        hash = JSON.parse(status)
        hash["success"] == true ? true : false    
      end
    end
  end
end
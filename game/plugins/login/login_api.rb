module AresMUSH
  module Login
    module Api
      def self.terms_of_service
        Login.terms_of_service
      end
      
      def self.is_guest?(char)
        Login.is_guest?(char)
      end
      
      def self.change_password(char, password)
        char.change_password(password)
      end
      
      def self.is_site_match?(char, ip, hostname)
        char.is_site_match?(ip, hostname)
      end
      
      def self.last_on(char)
        char.login_status ? char.login_status.last_on : nil
      end  
    end
  end
end

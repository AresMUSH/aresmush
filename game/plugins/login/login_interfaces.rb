module AresMUSH
  module Login
    
    class CharCreatedEvent
      attr_accessor :client
      
      def initialize(client)
        self.client = client
      end
    end
    
    module Interface
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
    end
  end
end

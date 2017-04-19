module AresMUSH
  class Character
    def is_guest?
      self.has_any_role?(Login.guest_role)
    end

    attribute :last_on, :type => DataType::Time
  end
  
  module Login
    module Api
      def self.terms_of_service
        Login.terms_of_service
      end
            
      def self.change_password(char, password)
        char.change_password(password)
      end
      
      def self.is_site_match?(char, ip, hostname)
        Login.is_site_match?(char, ip, hostname)
      end
      
      def self.login_char(char, client)
        Login.login_char(char, client)
      end
      
      def self.set_random_password(char)
        password = Character.random_link_code
        char.change_password(password)
        password
      end
    end
  end
end

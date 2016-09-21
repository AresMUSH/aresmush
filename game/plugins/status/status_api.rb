module AresMUSH
  module Status
    module Api
      def self.status_color(status)
        Status.status_color(status)
      end
    
      def self.is_idle?(client)
        Status.is_idle?(client)
      end
    
      def self.afk_message(char)
        char.afk_message
      end
    
      def self.is_afk?(char)
        char.is_afk?
      end
    
      def self.is_on_duty?(char)
        char.is_on_duty?
      end
    
      def self.is_ic?(char)
        char.is_ic?
      end
    
      def self.status(char)
        char.status
      end
    end
  end  
end
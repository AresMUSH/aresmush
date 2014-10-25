module AresMUSH
  module Api
    class RegisterUpdateResponseHandler
      include ApiResponseHandler
      
      def self.commands
        ["register/update"]
      end
      
      def self.available_on_master?
        true
      end
    
      def self.available_on_slave?
        true
      end
      
      def handle   
        Global.logger.info "Game registration successfully updated."
      end
    end
  end
end
module AresMUSH
  module Handles
    class ProfileResponseHandler
      include ApiResponseHandler
      
      def self.commands
        ["profile"]
      end
      
      def self.available_on_master?
        false
      end
    
      def self.available_on_slave?
        true
      end      
      
      def handle   
        client.emit response.args_str
      end
    end
  end
end
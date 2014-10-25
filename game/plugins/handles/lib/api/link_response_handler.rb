module AresMUSH
  module Handles
    class LinkResponseHandler
      include ApiResponseHandler
      
      def self.commands
        ["link"]
      end
      
      def self.available_on_master?
        false
      end
    
      def self.available_on_slave?
        true
      end
      
      def handle   
        client.char.handle = response.args_str
        client.char.save!
        client.emit_success t('handles.link_successful', :handle => response.args_str, :privacy => client.char.handle_privacy)
      end
    end
  end
end
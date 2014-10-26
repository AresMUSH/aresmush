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
        char = client.char
        char.handle = response.args_str
        char.handle_privacy = Handles.privacy_friends
        char.save!
        client.emit_success t('handles.link_successful', :handle => response.args_str)
        client.emit_ooc t('handles.privacy_set', :value => char.handle_privacy)
      end
    end
  end
end
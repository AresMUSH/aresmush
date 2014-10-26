module AresMUSH
  module Handles
    class LinkResponseHandler
      include ApiResponseHandler
      
      attr_accessor :args
      
      def self.commands
        ["link"]
      end
      
      def self.available_on_master?
        false
      end
    
      def self.available_on_slave?
        true
      end
      
      def crack!
        self.args = ApiLinkResponseArgs.create_from(response.args_str)
      end
      
      def validate
        return self.args.validate
      end
      
      def handle   
        char = client.char
        char.handle = self.args.handle_name
        char.handle_friends = self.args.handle_friends.split(" ")
        char.handle_privacy = Handles.privacy_friends
        char.save!
        client.emit_success t('handles.link_successful', :handle => response.args_str)
        client.emit_ooc t('handles.privacy_set', :value => Handles.privacy_friends)
      end
    end
  end
end
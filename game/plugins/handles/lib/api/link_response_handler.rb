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
        char.handle_privacy = Handles.privacy_friends
        char.handle_sync = true
        char.save!
        client.emit_success t('handles.link_successful', :handle => self.args.handle_name)
        client.emit_ooc t('handles.privacy_set', :value => Handles.privacy_friends)
        Api.sync_char_with_master(client)
      end
    end
  end
end
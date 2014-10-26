module AresMUSH
  module Api
    class LoginResponseHandler
      include ApiResponseHandler

      def self.commands
        ["login"]
      end
      
      def self.available_on_master?
        false
      end
    
      def self.available_on_slave?
        true
      end
    
      def handle
        handle_friends = response.args_str
        Global.logger.info "Login update received for #{client.name}."
        
        client.char.handle_friends = handle_friends.split(" ")
        client.char.save!
        client.emit_ooc t('api.handle_friends_updated')
      end
    end
  end
end
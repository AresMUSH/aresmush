module AresMUSH
  module Api
    class SyncResponseHandler
      include ApiResponseHandler

      attr_accessor :args
      
      def self.commands
        ["sync"]
      end
      
      def self.available_on_master?
        false
      end
    
      def self.available_on_slave?
        true
      end
      
      def crack!
        self.args = ApiSyncResponseArgs.create_from(response.args_str)
      end
      
      def validate
        return args.validate
      end
    
      def handle
        Global.logger.info "Login update received for #{client.name}."
        
        char = client.char
        
        return if !update_needed(char)
        
        char.handle_friends = self.args.friends.split(" ")
        if (char.handle_sync)
          char.autospace = self.args.autospace
          char.timezone = self.args.timezone
          client.emit_ooc t('api.handle_synced')
        end
        char.save!
      end
      
      def update_needed(char)
        char.handle_friends != self.args.friends.split(" ") ||
        char.autospace != self.args.autospace ||
        char.timezone != self.args.timezone
      end
    end
  end
end
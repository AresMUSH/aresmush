module AresMUSH
  module Api
    class SyncCmdHandler
      include ApiCommandHandler
      
      attr_accessor :args
      
      def self.commands
        ["sync"]
      end
      
      def self.available_on_master?
        true
      end
      
      def self.available_on_slave?
        false
      end
      
      def crack!
        self.args = ApiSyncCmdArgs.create_from(cmd.args_str)
      end
      
      def validate
        return args.validate
      end
      
      def handle
        char_name = args.handle_name.after("@")
        
        Global.logger.debug "Updating last login for #{char_name}."
        char = Character.find_by_name(char_name)
        if (char.nil?)
          return cmd.create_error_response t('api.invalid_handle')
        end
        
        linked_char = char.linked_characters[args.char_id]
        if (!linked_char)
          return cmd.create_error_response t('api.character_not_linked')
        end

        linked_char["last_login"] = Time.now
        linked_char["privacy"] = args.privacy
        linked_char["name"] = args.char_name
        char.save!
        
        friends = char.friends.map { |f| "@#{f.name}" }

        args = ApiSyncResponseArgs.new(friends.join(" "), char.autospace, char.timezone)
        return cmd.create_response(ApiResponse.ok_status, args.to_s)
      end
    end
  end
end
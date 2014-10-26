module AresMUSH
  module Handles
    class LinkCmdHandler
      include ApiCommandHandler
      attr_accessor :args
      
      def self.commands
        ["link"]
      end
      
      def self.available_on_master?
        true
      end
      
      def self.available_on_slave?
        false
      end
      
      def crack!
        self.args = ApiLinkCmdArgs.create_from(cmd.args_str)
      end
      
      def validate
        return args.validate
      end
      
      def handle
        Global.logger.debug "Linking #{args.char_id} to #{args.handle_name}."
        
        char_name = args.handle_name.after("@")

        char = Character.find_by_name(char_name)
        if (char.nil?)
          return cmd.create_error_response t('api.invalid_handle')
        end
        
        if (char.linked_characters.has_key?(args.char_id))
          return cmd.create_error_response t('handles.character_already_linked')
        end
        
        if (char.temp_link_codes[args.char_id] != args.code)
          return cmd.create_error_response t('handles.invalid_link_code')
        end
        
        char.linked_characters[args.char_id] = 
        {
          "name" => args.name,
          "game_id" => game_id
        }
        char.temp_link_codes.delete args.char_id
        char.save!
        
        args = ApiLinkResponseArgs.new("@#{char.name}", char.friends.map { |f| "@#{f.name}" }.join(" ") )
        return cmd.create_response(ApiResponse.ok_status, args.to_s)
      end
    end
  end
end
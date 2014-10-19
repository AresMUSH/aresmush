module AresMUSH
  module Api
    class LinkCmdHandler < ApiCommandHandler
      attr_accessor :args
      
      def crack!
        self.args = ApiLinkCmdArgs.create_from(cmd.args_str)
      end
      
      def validate
        return args.validate
      end
      
      def handle
        Global.logger.debug "Linking #{args.char_id} to #{args.handle}."
        
        char_name = args.handle.after("@")
        char = Character.find_by_name(char_name).first
        if (char.nil?)
          return cmd.create_error_response "Invalid handle."
        end
        
        if (char.linked_characters.has_key?(args.char_id))
          return cmd.create_error_response "This character is already linked to your handle."
        end
        
        if (char.temp_link_codes[args.char_id] != args.code)
          return cmd.create_error_response "Invalid link code.  Please check the code and try again."
        end
        
        char.linked_characters[args.char_id] = 
        {
          "name" => args.name,
          "game_id" => game_id
        }
        char.save!
        return cmd.create_response(ApiResponse.ok_status, "@#{char.name}")
      end
    end
  end
end
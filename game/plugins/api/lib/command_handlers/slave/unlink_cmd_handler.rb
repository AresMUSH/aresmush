module AresMUSH
  module Api
    class UnlinkCmdHandler < ApiCommandHandler
      attr_accessor :args
      
      def crack!
        self.args = ApiUnlinkCmdArgs.create_from(cmd.args_str)
      end
      
      def validate
        return args.validate
      end
      
      def handle
        Global.logger.debug "Unlinking #{args.char_id} from #{args.handle_name}."
        
        char = Character.all.select { |c| c.api_character_id == args.char_id }.first
        
        if (char.nil?)
          return cmd.create_error_response "Invalid character ID."
        end
        
        if (char.handle != args.handle_name)
          return cmd.create_error_response "This character is not linked to that handle."
        end
        
        char.handle = nil
        char.save!
        return cmd.create_ok_response
      end
    end
  end
end
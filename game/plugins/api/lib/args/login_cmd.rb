module AresMUSH
  module Api
    class ApiLoginCmdArgs
      attr_accessor :char_id, :handle_name, :char_name, :privacy
      
      def initialize(char_id, handle_name, char_name, privacy)
        self.char_id = char_id
        self.handle_name = handle_name
        self.char_name = char_name
        self.privacy = privacy
      end
      
      def to_s
        "#{handle_name}||#{char_id}||#{char_name}||#{privacy}"
      end
      
      def validate
        return "Missing character id." if self.char_id.blank?
        return "Invalid handle name.  Make sure it starts with @." if !Handles.handle_name_valid?(self.handle_name)
        return "Missing character name." if self.char_name.blank?
        return "Missing privacy." if self.privacy.blank?
        return nil
      end
     
      def self.create_from(command_args)
        handle_name, char_id, char_name, privacy = command_args.split("||")
        ApiFriendCmdArgs.new(char_id, handle_name, char_name, privacy)
      end
    end
  end
end
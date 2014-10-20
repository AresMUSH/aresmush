module AresMUSH
  module Api
    class ApiLinkCmdArgs
      attr_accessor :handle_name, :char_id, :name, :code
      
      def initialize(handle_name, char_id, name, code)
        self.handle_name = handle_name
        self.char_id = char_id
        self.name = name
        self.code = code
      end
      
      def to_s
        "#{handle_name}||#{char_id}||#{name}||#{code}"
      end
      
      def validate
        return "Invalid handle name.  Make sure it starts with @." if !Handles.handle_name_valid?(self.handle_name)
        return "Missing character id." if self.char_id.blank?
        return "Missing name." if self.name.blank?
        return "Missing link code." if self.code.blank?
        return nil
      end
     
      def self.create_from(command_args)
        handle_name, char_id, name, code = command_args.split("||")
        ApiLinkCmdArgs.new(handle_name, char_id, name, code)
      end
    end
  end
end
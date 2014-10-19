module AresMUSH
  module Api
    class ApiLinkCmdArgs
      attr_accessor :handle, :char_id, :name, :code
      
      def initialize(handle, char_id, name, code)
        self.handle = handle
        self.char_id = char_id
        self.name = name
        self.code = code
      end
      
      def to_s
        "#{handle}||#{char_id}||#{name}||#{code}"
      end
      
      def validate
        return "Missing handle." if self.handle.blank?
        return "Missing character id." if self.char_id.blank?
        return "Missing name." if self.name.blank?
        return "Missing link code." if self.code.blank?
        return nil
      end
     
      def self.create_from(command_args)
        handle, char_id, name, code = command_args.split("||")
        ApiLinkCmdArgs.new(handle, char_id, name, code)
      end
    end
  end
end
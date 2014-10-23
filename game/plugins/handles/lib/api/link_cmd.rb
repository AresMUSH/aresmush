module AresMUSH
  module Handles
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
        return t('api.invalid_handle') if !Handles.handle_name_valid?(self.handle_name)
        return t('api.invalid_char_id') if self.char_id.blank?
        return t('api.invalid_name') if self.name.blank?
        return t('handles.invalid_link_code') if self.code.blank?
        return nil
      end
     
      def self.create_from(command_args)
        handle_name, char_id, name, code = command_args.split("||")
        ApiLinkCmdArgs.new(handle_name, char_id, name, code)
      end
    end
  end
end
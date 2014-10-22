module AresMUSH
  module Api
    class ApiCommand
      attr_accessor :command_name, :args_str
      
      def initialize(command_name, args_str)
        @command_name = command_name
        @args_str = args_str
      end
      
      def to_s
        if (args_str.nil? || args_str.empty?)
          "#{command_name}"
        else
          "#{command_name} #{args_str}"
        end
      end
      
      def self.create_from(cmd_str)
        cracked = /(?<command>\S+)\s?(?<args>.*)?/.match(cmd_str)
        raise "Invalid command format: #{cmd_str}." if cracked.nil?
      
        self.new(cracked[:command], cracked[:args])
      end
      
      def create_response(status, args_str)
        ApiResponse.new(@command_name, status, args_str)
      end

      def create_ok_response
        ApiResponse.new(@command_name, ApiResponse.ok_status)
      end
      
      def create_error_response(error)
        ApiResponse.new(@command_name, ApiResponse.error_status, error)
      end
    end
  end
end
module AresMUSH
  module Api
    class ApiResponse
      attr_accessor :command_name, :status, :args
    
      def initialize(command_name, status, args = "")
        @command_name = command_name
        @status = status
        @args = args
      end
    
      def to_s
        "#{command_name} #{status} #{args}" 
      end
    
      def is_success?
        @status == self.ok_status
      end
    
      def self.error_status
        "ERR"
      end
    
      def self.ok_status
        "OK"
      end
    
      def self.create_from(response_str)
        cracked = /(?<command>\S+) (?<status>\S+)\s?(?<args>.*)/.match(response_str)
        raise "Invalid response format: #{response_str}." if cracked.nil?
      
        self.new(cracked[:command], cracked[:status], cracked[:args])
      end
      
      def self.create_ok_response(cmd)
        self.new(cmd.command_name, ApiResponse.ok_status)
      end
      
      def self.create_error_response(cmd, error)
        self.new(cmd.command_name, ApiResponse.error_status, error)
      end
      
      def self.create_command_response(cmd, status, args)
        self.new(cmd.command_name, status, args)
      end
    end
  end
end
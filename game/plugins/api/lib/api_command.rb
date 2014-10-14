module AresMUSH
  module Api
    class ApiCommand
      attr_accessor :command_name, :args
      
      def initialize(command_name, args)
        @command_name = command_name
        @args = args
      end
      
      def to_s
        "#{command_name} #{args}"
      end
      
      def self.create_from(cmd_str)
        cracked = /(?<command>\S+) (?<args>.*)/.match(cmd_str)
        raise "Invalid command format: #{cmd_str}." if cracked.nil?
      
        self.new(cracked[:command], cracked[:args])
      end
    end
  end
end
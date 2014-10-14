module AresMUSH
  module Api
    class ApiRegisterCmdArgs
      attr_accessor :host, :port, :name, :category, :desc, :command_name
      
      def initialize(host, port, name, category, desc)
        @host = host
        @port = Integer(port) rescue nil
        @name = name
        @category = category
        @desc = desc
      end
      
      def to_s
        "#{host}||#{port}||#{name}||#{category}||#{desc}"
      end
      
      def validate
        return "Invalid host." if host.nil?
        return "Invalid port." if port.nil?
        return "Invalid name." if name.nil?
        return "Invalid category." if !ServerInfo.categories.include?(category)
        return "Invalid description." if desc.nil?
        return nil
      end
      
      def self.create_from(command_args)
        args = command_args.split("||")
        host, port, name, category, desc = args
        ApiRegisterCmdArgs.new(host, port, name, category, desc)
      end
    end
  end
end
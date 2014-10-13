module AresMUSH
  module Api
    class ApiRegistrationCmd
      attr_accessor :game_id, :host, :port, :name, :category, :desc
      
      def initialize(game_id, host, port, name, category, desc)
        @game_id = game_id
        @host = host
        @port = port
        @name = name
        @category = category
        @desc = desc
      end
      
      def command_name
        raise NotImplementedError
      end
      
      def command_string
        "#{command_name} #{@host}||#{@port}||#{@name}||#{@category}||#{@desc}"
      end
      
      def build_response(game_id, api_key)
        ApiResponse.create_command_response(self, ApiResponse.ok_status, "#{game_id}||#{api_key}")
      end
      
      def self.create_from(game_id, command_str)
        args = command_str.split("||")
        host, port, name, category, desc = args
        ApiRegisterCmd.new(game_id, host, port, name, category, desc)
      end
      
      def validate
        @port = Integer(@port) rescue nil
        @game_id = Integer(@game_id) rescue nil
        return "Invalid host." if @host.nil?
        return "Invalid port." if @port.nil?
        return "Invalid name." if @name.nil?
        return "Invalid category." if !ServerInfo.categories.include?(@category)
        return "Invalid description." if @desc.nil?
        return nil
      end
    end
      
    class ApiRegisterCmd < ApiRegistrationCmd
      def command_name
        "register"
      end
    end
    
    class ApiRegisterUpdateCmd < ApiRegistrationCmd
      def command_name
        "register/update"
      end
    end
  end
end
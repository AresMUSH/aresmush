module AresMUSH
  module Api
    class ApiRegisterCmdArgs
      attr_accessor :host, :port, :name, :category, :desc, :command_name
      
      def initialize(host, port, name, category, desc)
        @host = host
        @port = port
        @name = name
        @category = category
        @desc = desc
      end
      
      def cmd_args_str
        "#{@host}||#{@port}||#{@name}||#{@category}||#{@desc}"
      end
      
      def validate
        @port = Integer(@port) rescue nil
        return "Invalid host." if @host.nil?
        return "Invalid port." if @port.nil?
        return "Invalid name." if @name.nil?
        return "Invalid category." if !ServerInfo.categories.include?(@category)
        return "Invalid description." if @desc.nil?
        return nil
      end
      
      def self.create_from(command_args)
        args = command_args.split("||")
        host, port, name, category, desc = args
        ApiRegisterCmdArgs.new(host, port, name, category, desc)
      end
    end
    
    class ApiRegisterResponseArgs
      attr_accessor :game_id, :key
      
      def initialize(game_id, key)
        @game_id = game_id
        @key = key
      end
      
      def response_args_str
        "#{@game_id}||#{@key}"
      end

      def validate
        @game_id = Integer(@game_id) rescue nil
        return "Invalid game ID." if @game_id.nil?
        return "Invalid key." if @key.nil?
      end
      
      def self.create_from(response_args)
        args = command_args.split("||")
        game_id, key = args
        ApiRegisterResponseArgs.new(game_id, key)
      end
    end
  end
end
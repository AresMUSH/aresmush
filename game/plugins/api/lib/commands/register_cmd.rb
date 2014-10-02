module AresMUSH
  module Api
    class ApiRegisterCmd
      attr_accessor :game_id, :host, :port, :name, :category, :desc

      def initialize(game_id, host, port, name, category, desc)
        @game_id = game_id
        @host = host
        @port = port
        @name = name
        @category = category
        @desc = desc
      end
      
      def build_command_str
        "register #{@host}||#{@port}||#{@name}||#{@category}||#{@desc}"
      end
      
      def self.create_from(game_id, command_str)
        args = command_str.split("||")
        host, port, name, category, desc = args
        ApiRegisterCmd.new(game_id, host, port, name, category, desc)
      end
    end
    
    class ApiRegisterCmdHandlerMaster
      def self.handle(cmd)      
        game = Api.get_destination(cmd.game_id)
        
        if (game.nil?)
          key = Api.generate_key
          game_id = ServerInfo.next_id

          Global.logger.info "Creating new game #{cmd.name}."

          ServerInfo.create(name: cmd.name, 
            category: cmd.category, 
            description: cmd.desc,
            host: cmd.host,
            port: cmd.port,
            key: key,
            game_id: game_id)
          
          "register #{game_id}||#{key}"
        else
          Global.logger.info "Updating existing game #{game.game_id} #{cmd.name}."

          game.category = cmd.category
          game.name = cmd.name
          game.description = cmd.desc
          game.host = cmd.host
          game.port = cmd.port
          game.save!
          
          game = Api.get_destination(cmd.game_id)
          
          "register #{game.game_id}||#{game.key}"
        end
      end
    end
  end
end
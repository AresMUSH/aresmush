module AresMUSH
  module Api
    class ApiRegisterUpdateCmd
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
        "register/update #{@host}||#{@port}||#{@name}||#{@category}||#{@desc}"
      end
      
      def self.create_from(game_id, command_str)
        args = command_str.split("||")
        host, port, name, category, desc = args
        ApiRegisterUpdateCmd.new(game_id, host, port, name, category, desc)
      end
    end
  end
end
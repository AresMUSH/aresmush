module AresMUSH
  module Api
    class ApiRegisterResponseArgs
      attr_accessor :game_id, :api_key
      
      def initialize(game_id, api_key)
        @game_id = Integer(game_id) rescue nil
        @api_key = api_key
      end
      
      def to_s
        "#{game_id}||#{api_key}"
      end

      def validate
        return "Invalid game ID." if game_id.nil?
        return "Invalid key." if api_key.nil?
      end
      
      def self.create_from(response_args)
        args = response_args.split("||")
        game_id, key = args
        ApiRegisterResponseArgs.new(game_id, key)
      end
    end
  end
end
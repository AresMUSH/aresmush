module AresMUSH
  module Api
    class ApiRegisterResponse
      attr_accessor :client, :game_id, :key
      
      def initialize(client, response_str)
        @client = client
        args = response_str.split("||")
        @game_id = Integer(args[0]) 
        @key = args[1]
      end
    end
  end
end
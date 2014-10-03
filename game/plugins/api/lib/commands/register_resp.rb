module AresMUSH
  module Api
    class ApiRegisterResponse
      attr_accessor :client, :game_id, :key, :raw
      
      def initialize(client, response_str)
        @client = client
        @raw = response_str
        args = response_str.split("||")
        @game_id, @key = args
      end
    end
  end
end
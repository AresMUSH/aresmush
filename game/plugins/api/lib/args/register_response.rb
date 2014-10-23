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
        return t('api.invalid_game_id') if game_id.blank?
        return t('api.invalid_key') if api_key.blank?
      end
      
      def self.create_from(response_args)
        args = response_args.split("||")
        game_id, key = args
        ApiRegisterResponseArgs.new(game_id, key)
      end
    end
  end
end
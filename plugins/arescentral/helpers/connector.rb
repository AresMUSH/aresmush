module AresMUSH

  module AresCentral
    
    class AresResponse
      def initialize(json)
        @response = json
      end
    
      def to_s
        @response.to_s
      end
    
      def is_success?
        @response["status"] == "success"
      end
    
      def data
        @response["data"]
      end
    
      def error_str
        return nil if is_success?
        @response["error"]
      end
    end
  
    class AresConnector
  
      def initialize
        url = Global.read_config("arescentral", "arescentral_url")
        @rest = RestConnector.new("#{url}/api")      
      end
  
      def get_handle_friends(handle_id)
        json = @rest.get("handle/#{handle_id}/friends")
        AresResponse.new(json)
      end
    
      def reset_password(handle_id, password, char_id)
        params = {
          password: password,
          char_id: char_id,
          api_key: Game.master.api_key,
          game_id: Game.master.api_game_id
        }
        json = @rest.post("handle/#{handle_id}/reset_password", params)
        AresResponse.new(json)
      end
      
      def link_char(handle_name, link_code, char_name, char_id)
        params = {
          handle_name: handle_name,
          char_name: char_name,
          link_code: link_code,
          char_id: char_id,
          api_key: Game.master.api_key,
          game_id: Game.master.api_game_id
        }
        json = @rest.post("handle/link", params)
        AresResponse.new(json)
      end
    
      def sync_handle(handle_id, char_name, char_id)
        params = {
          char_name: char_name,
          char_id: char_id,
          api_key: Game.master.api_key,
          game_id: Game.master.api_game_id
        }
        json = @rest.post("handle/#{handle_id}/sync", params)
        AresResponse.new(json)
      end
      
      def unlink_handle(handle_id, char_name, char_id)
        params = {
          char_name: char_name,
          char_id: char_id,
          api_key: Game.master.api_key,
          game_id: Game.master.api_game_id
        }
        json = @rest.post("handle/#{handle_id}/unlink", params)
        AresResponse.new(json)
      end
      
      def update_game(params)
        params[:api_key] = Game.master.api_key
        json = @rest.post("game/#{Game.master.api_game_id}/update", params)
        AresResponse.new(json)
      end

      def register_game(params)
        json = @rest.post("game/register", params)
        AresResponse.new(json)
      end
      
    end
  end
end
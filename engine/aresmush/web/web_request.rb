module AresMUSH
  class WebRequest
    attr_accessor :json, :ip_addr, :hostname
    
    def initialize(json)
      @json = json
    end
    
    def cmd
      @json[:cmd]
    end
    
    def args
      @json[:args] || {}
    end
    
    def api_key
      @json[:api_key]
    end
    
    def check_api_key
      key = @json[:api_key]
      return true if Website.engine_api_keys.include?(key)
      return Game.master.player_api_keys && Game.master.player_api_keys.has_key?(key)
    end
    
    def auth
      @json[:auth] || {}
    end
    
    def token
      auth[:token]
    end
    
    def enactor
      id = auth[:id]
      id ? Character.find_one_by_name(id) : nil
    end
  end
end
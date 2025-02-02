module AresMUSH
  class WebRequest
    attr_accessor :ip_addr, :hostname, :cmd, :args, :api_key, :auth, :json
    
    def initialize(json)
      @json = json
      @cmd = json["cmd"]
      @args = (json["args"] || {})
      @api_key = json["api_key"]
      @auth = (json["auth"] || {}) #.transform_keys(&:to_sym)
      
      #
      #
      # TODO !!!
      #
      #
      #
      puts @args
      puts @auth
    end
    
    def check_api_key
      key = self.api_key
      return true if Website.engine_api_keys.include?(key)
      return Game.master.player_api_keys && Game.master.player_api_keys.has_key?(key)
    end
    
    def token
      @auth['token']
    end
    
    def enactor
      id = @auth['id']
      id ? Character.find_one_by_name(id) : nil
    end
    
    def log_request
      Global.logger.debug "Web Request: #{cmd} #{@auth["id"]} #{args} #{enactor ? enactor.name : "Anonymous"}"
    end
  end
end
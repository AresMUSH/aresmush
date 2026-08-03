module AresMUSH
  class WebRequest
    attr_accessor :ip_addr, :hostname, :cmd, :args, :api_key, :auth, :json
    
    def initialize(json)
      @json = json
      @cmd = json["cmd"]
      @args = (json["args"] || {})
      @api_key = json["api_key"]
      @auth = (json["auth"] || {}) #.transform_keys(&:to_sym)
    end
    
    def check_api_key
      return Website.check_api_key(self.api_key)
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
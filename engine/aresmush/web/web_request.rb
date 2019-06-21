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
    
    def check_api_key
      Website.engine_api_keys.include?(@json[:api_key])
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
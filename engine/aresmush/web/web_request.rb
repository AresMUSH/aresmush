module AresMUSH
  class WebRequest
    attr_accessor :json
    
    def initialize(json)
      @json = json
    end
    
    def cmd
      @json[:cmd]
    end
    
    def args
      @json[:args]
    end
    
    def check_api_key
      @json[:api_key] == Game.master.engine_api_key
    end
  end
end
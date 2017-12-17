module AresMUSH
  class EngineApiConnector
    def initialize
      port = Global.read_config("server", "engine_api_port")
      host = Global.read_config("server", "hostname")
      @rest = AresMUSH::RestConnector.new("http://#{host}:#{port}")    
    end
    
    def who
      data = @rest.get("/api/who")
      return data['who']
    end
    
    def notify(type, msg, ooc, char_ids)
      args = { :type => type, :ooc => ooc, :chars => char_ids.join(','), :message => msg }
      data = post("/api/notify", args)        
      return data['status'] == 'OK' ? nil : data['error']
    end
    
    def reload_config
      data = post("/api/config/load", {})
      return data['status'] == 'OK' ? nil : data['error']
    end
    
    def character_created(id)
      data = post("/api/char/created", { id: id })
      return data['status'] == 'OK' ? nil : data['error']
    end
    
    def reload_tinker
      data = post("/api/tinker/load", {})
      return data['status'] == 'OK' ? nil : data['error']
    end
    
    def post(url, args)
      args['api_key'] = Game.master.engine_api_key
      @rest.post(url, args)
    end
  end
end
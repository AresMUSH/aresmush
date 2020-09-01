module AresMUSH
  class RestConnector
    def initialize(baseUrl)
      @baseUrl = baseUrl
      @connector = HttpConnector.new
    end
    
    def get(action)
      url = build_url(action)
      resp = @connector.get(url)
      if (resp && resp.body)
        return JSON.parse(resp.body)
      else
        return nil
      end
    end
    
    def post(action, params)
      url = build_url(action)
      resp = @connector.post(url, params)
      if (resp && resp.body)
        return JSON.parse(resp.body)
      else
        return nil
      end
    end
    
    def build_url(action)
      if (action.blank?)
        return @baseUrl
      else
        return "#{@baseUrl}/#{action}"
      end
    end
  end
end
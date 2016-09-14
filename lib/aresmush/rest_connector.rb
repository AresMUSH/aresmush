module AresMUSH
  class RestConnector
    def initialize(baseUrl)
      @baseUrl = baseUrl
    end
    
    def get(action)
      url = "#{@baseUrl}/#{action}"
      resp = Net::HTTP.get_response(build_uri(action))
      JSON.parse(resp.body)
    end
    
    def post(action, params)
      resp = Net::HTTP.post_form(build_uri(action), params)
      JSON.parse(resp.body)
    end
    
    def build_uri(action)
      url = "#{@baseUrl}/#{action}"
      URI.parse(url)
    end
  end
end
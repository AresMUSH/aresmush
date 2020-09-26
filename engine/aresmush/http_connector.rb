module AresMUSH
  class HttpConnector
    def get(url)
      uri = URI.parse(url)
      opts = { open_timeout: 1, read_timeout: 1, use_ssl: uri.scheme == "https" }
      Net::HTTP.start(uri.hostname, uri.port, opts ) do |http|
        resp = http.request_get(uri.request_uri)
        return resp
      end
    end
    
    def post(url, params)
      uri = URI.parse(url)
      opts = { open_timeout: 1, read_timeout: 1, use_ssl: uri.scheme == "https" }
      Net::HTTP.start(uri.hostname, uri.port, opts ) do |http|
        req = Net::HTTP::Post.new(uri)
        req.form_data = params
        resp = http.request(req)
        return resp
      end
    end
  end
end

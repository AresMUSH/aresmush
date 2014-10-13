module AresMUSH
  class ApiResponseEvent
    attr_accessor :response, :client

    def initialize(client, response)
      @client = client
      @response = response
    end
  end
end
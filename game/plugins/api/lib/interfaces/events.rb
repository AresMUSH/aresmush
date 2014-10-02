module AresMUSH
  class ApiResponseEvent
    attr_accessor :client, :response, :error

    def initialize(client, response, error)
      @client = client
      @response = response
      @error = error
    end
  end
end
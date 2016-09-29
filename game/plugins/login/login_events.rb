module AresMUSH
  class CharCreatedEvent
    attr_accessor :client, :char
    
    def initialize(client)
      # TODO
      self.char = client.char
      self.client = client
    end
  end
end

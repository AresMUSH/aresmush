module AresMUSH
  class CharApprovedEvent
    attr_accessor :client, :char_id

    def initialize(client, char_id)
      self.client = client
      self.char_id = char_id
    end
  end
end
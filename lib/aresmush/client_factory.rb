module AresMUSH
  class ClientFactory
    def initialize
      @next_id = 0
    end
    
    def new_client(session)
      @next_id = @next_id + 1
      Client.new(@next_id, session)
    end
  end
end

module AresMUSH
  class ClientFactory
    def initialize(dispatcher)
      @client_id = 0
      @dispatcher = dispatcher
    end
    
    def create_client(connection, client_monitor)
      @client_id = @client_id + 1   
      client = Client.new(@client_id, client_monitor, connection, @dispatcher)       
      connection.client = client
      client
    end
  end
end
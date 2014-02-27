module AresMUSH
  class ClientFactory
    def initialize
      @client_id = 0
    end
    
    def create_client(connection)
      @client_id = @client_id + 1   
      client = Client.new(@client_id, connection)       
      connection.client = client
      client
    end
  end
end
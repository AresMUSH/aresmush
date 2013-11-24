module AresMUSH
  class ClientFactory
    def initialize
      @client_id = 0
    end
    
    def create_client(connection)
      @client_id = @client_id + 1   
      client = Client.new(@client_id, Global.container.client_monitor, Global.container.config_reader, connection)       
      connection.client = client
      client
    end
  end
end
module AresMUSH
  class ClientFactory
    def initialize(config_reader)
      @config_reader = config_reader
      @client_id = 0
    end
    
    def create_client(connection, client_monitor)
      @client_id = @client_id + 1   
      client = Client.new(@client_id, client_monitor, @config_reader, connection)       
      connection.client = client
      client
    end
  end
end
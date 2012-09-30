require 'ansi'

module AresMUSH
  class ClientMonitor
    def initialize(config_reader)
      @clients = []
      @client_id = 0
      @config_reader = config_reader
    end

    def tell_all(msg)
      @clients.each do |c|
        c.emit msg
      end
    end

    def connection_established(connection)
      @client_id = @client_id + 1   
      client = Client.new(@client_id, self, @config_reader, connection)       
      connection.client = client
      client.connected
      @clients << client
      tell_all "Client #{client.id} connected"
    end

    def connection_closed(client)
      @clients.delete client
      tell_all "Client #{client.id} disconnected"
    end
  end
end
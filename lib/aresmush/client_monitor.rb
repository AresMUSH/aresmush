require 'ansi'

module AresMUSH
  class ClientMonitor
    def initialize(config_reader, dispatcher)
      @clients = []
      @client_id = 0
      @config_reader = config_reader
      @dispatcher = dispatcher
    end

    attr_reader :clients, :client_id

    def emit_all(msg)
      @clients.each do |c|
        c.emit msg
      end
    end

    def connection_established(connection)
      begin
        client = create_client(connection)
        @clients << client
        client.connected
        @dispatcher.on_event(:connection_established, :client => client)
        logger.info("Client connected from #{connection.ip_addr}. ID=#{client.id}.")
      rescue Exception => e
        logger.debug "Error establishing connection #{e}."
      end
    end

    def connection_closed(client)
      logger.info("Client #{client.id} disconnected.")
      @clients.delete client
      @dispatcher.on_event(:player_disconnected, :client => client)
    end

    def handle_client_input(client, input)
      @dispatcher.on_command(client, Command.new(client, input))
    end
    
    private
    def create_client(connection)
      @client_id = @client_id + 1   
      client = Client.new(@client_id, self, @config_reader, connection)       
      connection.client = client
      client
    end
  end
end
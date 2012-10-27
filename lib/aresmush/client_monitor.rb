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

    def tell_all(msg)
      @clients.each do |c|
        c.emit msg
      end
    end

    def connection_established(connection)
      begin
        @client_id = @client_id + 1   
        client = Client.new(@client_id, self, @config_reader, connection)       
        connection.client = client
        client.connected
        @clients << client
        logger.info("Client connected from #{connection.ip_addr}. ID=#{client.id}.")
        @dispatcher.on_event(:player_connected, :client => client)
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
      @dispatcher.on_player_command(client, input)
    end
  end
end
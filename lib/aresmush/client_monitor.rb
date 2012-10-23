require 'ansi'

module AresMUSH
  class ClientMonitor
    def initialize(config_reader)
      @clients = []
      @client_id = 0
      @config_reader = config_reader
      
      # TODO: Doesn't belong here
      @systems = []
    end

    attr_reader :clients, :client_id
    
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
      
      # TODO - raise system event
      tell_all "Client #{client.id} connected"
    end

    def connection_closed(client)
      @clients.delete client
      
      # TODO - raise system event
      tell_all "Client #{client.id} disconnected"
    end
    
    # TODO: Doesn't belong here
    def register(system)
      @systems << system
    end
    
    # TODO: Doesn't belong here either
    def handle(client, cmd)
      begin
         @systems.each do |s|
           s.handles.each do |regex|
              match = /^#{regex}/.match(cmd)
              if (!match.nil?)
                s.handle(client, match)
              end
           end
         end 
      rescue Exception => e
        # TODO: log
        tell_all "Bad code did badness! #{e}"
      end
    end
  end
end
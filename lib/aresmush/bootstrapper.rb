module AresMUSH

  class Bootstrapper 

    def initialize
      # TODO - create config reader
      config = { 'server' => { 'port' => 7207 } }

      server = TCPServer.open config['server']['port']
      client_listener = ClientListener.new
      server_controller = AresMUSH::ServerController.new(server, config, client_listener)
      @client = AresMUSH::Client.new(server_controller)
    end

    def client
      @client
    end
  end

end
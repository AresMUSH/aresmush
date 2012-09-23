module AresMUSH

  class Bootstrapper 

    def initialize
      # TODO - create config reader
      config = { 'server' => { 'port' => 7207 } }

      # TODO - should use TCPServer.new instead of TCPServer.open
      server_controller = AresMUSH::ServerController.new(TCPServer, config)
      @client = AresMUSH::Client.new(server_controller)
    end

    def client
      @client
    end
  end

end
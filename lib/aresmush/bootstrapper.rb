module AresMUSH

  class Bootstrapper 

    def initialize
      config_reader = AresMUSH::ConfigReader.new(Dir.pwd)
      config_reader.read
      
      server = TCPServer.open config_reader.config['server']['port']
      client_listener = ClientListener.new
      server_controller = AresMUSH::ServerController.new(server, config_reader.config, client_listener)
      @client = AresMUSH::Client.new(server_controller)
    end

    def client
      @client
    end
  end

end
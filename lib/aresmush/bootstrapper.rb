module AresMUSH

  class Bootstrapper 

    def initialize
      config_reader = ConfigReader.new(Dir.pwd + "/game")
      config_reader.read
      
      client_factory = ClientFactory.new
      connection_monitor = AresMUSH::ConnectionMonitor.new(config_reader)
      server = TCPServer.open config_reader.config['server']['port']
      client_listener = ClientListener.new(connection_monitor, client_factory)
      server_controller = AresMUSH::ServerController.new(server, config_reader, client_listener)
      @command_line = AresMUSH::CommandLine.new(server_controller)
    end

    def command_line
      @command_line
    end
  end

end
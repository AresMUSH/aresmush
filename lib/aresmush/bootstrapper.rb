module AresMUSH

  class Bootstrapper 

    def initialize
      config_reader = AresMUSH::ConfigReader.new(Dir.pwd + "/game")
      config_reader.read
      
      connection_monitor = AresMUSH::ConnectionMonitor.new(config_reader)
      server = TCPServer.open config_reader.config['server']['port']
      client_listener = ClientListener.new(connection_monitor)
      server_controller = AresMUSH::ServerController.new(server, config_reader, client_listener)
      @command_line = AresMUSH::CommandLine.new(server_controller)
    end

    def command_line
      @command_line
    end
  end

end
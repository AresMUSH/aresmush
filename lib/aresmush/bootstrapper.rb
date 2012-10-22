module AresMUSH

  class Bootstrapper 

    attr_reader :command_line
    
    def initialize
      config_reader = ConfigReader.new(Dir.pwd + "/game")
      config_reader.read
      port = config_reader.config['server']['port']

      client_monitor = ClientMonitor.new(config_reader)
      
      locale = Locale.new(config_reader, Dir.pwd + "/locales")
      
      server = Server.new(config_reader, client_monitor)
      @command_line = AresMUSH::CommandLine.new(server)
      locale.setup
      
      puts Dir.pwd
      systems = Dir[File.join(Dir.pwd + "/systems/**/*.rb")]
      systems.each do |f| 
        puts "Including" + f
        require f
      end unless systems.empty?

      w1 = ServerEvents::Quit.new(config_reader, client_monitor)
      w2 = ServerEvents::ServerConfig.new(config_reader, client_monitor)
      w3 = ServerEvents::Say.new(config_reader, client_monitor)
      w4 = ServerEvents::Who.new(config_reader, client_monitor)
    end    
  end

end
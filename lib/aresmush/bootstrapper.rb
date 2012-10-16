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
      widgets = Dir[File.join(Dir.pwd + "/widgets/**/*.rb")]
      widgets.each do |f| 
        puts "Including" + f
        require f
      end unless widgets.empty?

      w1 = ServerEvents::ServerEvents.new(config_reader, client_monitor)
    end    
  end

end
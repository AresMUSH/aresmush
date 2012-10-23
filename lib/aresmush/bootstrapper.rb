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
        #require f
        load f
      end unless systems.empty?

      systems = AresMUSH::Commands.constants.select {|c| Class === AresMUSH::Commands.const_get(c).new(config_reader, client_monitor)}
      systems.each do |s|
        puts s.name
      end
      
    end    
  end

end
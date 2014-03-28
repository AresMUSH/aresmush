module AresMUSH

  class CommandLine

    def initialize(server)
      @server = server
    end
    
    def start
      raise "Game DB not initialized!" if Game.master.nil?
      @server.start
    end
  end
end
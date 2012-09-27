require 'socket'

module AresMUSH

  class CommandLine

    def initialize(server)
      @server = server
    end
    
    def start
      @server.start
    end
  end
end
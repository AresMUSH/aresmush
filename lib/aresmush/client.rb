require 'socket'

module AresMUSH

  class Client

    def initialize(server)
      @server = server
    end
    
    def start
      @server.start
    end
  end
end
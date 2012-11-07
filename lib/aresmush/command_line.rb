module AresMUSH

  class CommandLine

    def initialize(server)
      @server = server
    end
    
    # TODO: Add specs
    def start
      @server.start
    end
  end
end
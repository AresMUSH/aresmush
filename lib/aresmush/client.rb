module AresMUSH
  class Client
    
    attr_reader :session, :id

    def initialize(id, session)
      @id = id
      @session = session
    end
    
    def ip
      @session.addr[3]
    end
    
    def host
      @session.addr[2]
    end
    
    def emit(str)
      @session.puts str
    end
  end
end
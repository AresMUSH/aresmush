module AresMUSH
  
  class ConnectionMonitor
    
    def initialize(config_reader)
      @config_reader = config_reader
    end
    
    def client_connected(client)
      # TODO
      puts client.addr
      client.puts ANSI.green + @config_reader.config['connect']['welcome_text'] + ANSI.reset
      connect_text = @config_reader.txt['connect']
      client.puts connect_text.to_ansi
    end

    def client_disconnected(client)
      puts "Client disconnected "
      puts client.addr
      # TODO
    end
    
    def client_input(client, line)
      # TODO
      puts line         
      client.puts("You typed: #{line}")
    end
    
  end
end
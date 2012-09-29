require 'ansi'

module AresMUSH
  class ClientMonitor
    def initialize(config_reader)
      @clients = []
      @config_reader = config_reader      
    end

    def tell_all(msg)
      @clients.each do |c|
        c.emit msg
      end
    end

    def add_client(client)
      @clients << client
      client.emit ANSI.green + @config_reader.config['connect']['welcome_text'] + ANSI.reset
      connect_text = @config_reader.txt['connect']
      client.emit connect_text.to_ansi
      tell_all "Client #{client.id} connected"
    end

    def rm_client(client)
      @clients.delete client
      tell_all "Client #{client.id} disconnected"
    end
  end
end
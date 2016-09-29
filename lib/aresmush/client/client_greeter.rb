module AresMUSH

  class ClientGreeter    
    def self.greet(client)
      connect_config = Global.read_config("connect")
      
      # Connect screen ansi
      filename = 'game/files/connect.txt'
      client.emit !filename ? nil : File.read(filename, :encoding => "UTF-8")

      # Ares welcome text
      client.emit_ooc t('client.welcome')

      # Game welcome text.
      welcome_text = connect_config['welcome_text']
      if (welcome_text)
        client.emit_ooc welcome_text
      end
    end
  end
end

    
    
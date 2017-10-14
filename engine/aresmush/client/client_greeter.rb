module AresMUSH

  class ClientGreeter    
    def self.greet(client)
      # Connect screen ansi
      filename = 'game/files/connect.txt'
      client.emit !filename ? nil : File.read(filename, :encoding => "UTF-8")

      # Ares welcome text
      client.emit_ooc t('client.welcome')
    end
  end
end

    
    
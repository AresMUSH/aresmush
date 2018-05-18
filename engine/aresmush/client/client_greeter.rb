module AresMUSH

  class ClientGreeter    
    def self.greet(client)
      # Connect screen ansi
      filename = 'game/text/connect.txt'
      client.emit !filename ? nil : File.read(filename, :encoding => "UTF-8")

      # Ares welcome text
      client.emit_ooc t('client.welcome', :version => AresMUSH.version ? AresMUSH.version.chomp : "")
    end
  end
end

    
    
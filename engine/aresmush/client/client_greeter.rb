module AresMUSH

  class ClientGreeter
    CONNECT_FILES = Dir["game/text/**/connect*.txt"]

    def self.greet(client)
      # Connect screen ansi
      filename = CONNECT_FILES.sample
      client.emit !filename ? nil : File.read(filename, :encoding => "UTF-8")

      # Ares welcome text
      client.emit_ooc t('client.welcome', :version => AresMUSH.version ? AresMUSH.version.chomp : "")
    end
  end
end

    
    

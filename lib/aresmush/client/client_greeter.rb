module AresMUSH

  class ClientGreeter    
    def self.greet(client)
      connect_config = Global.config['connect']
      
      # Connect screen ansi
      filename = connect_config['welcome_screen']
      client.emit filename.nil? ? nil : File.read(filename)

      # Ares welcome text
      client.emit_ooc t('client.welcome')

      # Game welcome text.
      client.emit_ooc connect_config['welcome_text']
    end
  end
end

    
    
module AresMUSH

  class ClientGreeter    
    def self.greet(client, connect_config)
      # Connect screen ansi
      client.emit connect_config['welcome_screen']

      # Ares welcome text
      client.emit_ooc t('client.welcome')

      # Game welcome text.
      client.emit_ooc connect_config['welcome_text']
    end
  end
end

    
    
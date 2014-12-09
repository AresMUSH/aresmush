module AresMUSH

  class ClientGreeter    
    def self.greet(client)
      connect_config = Global.config['connect']
      
      # Connect screen ansi
      filename = connect_config['welcome_screen']
      client.emit filename.nil? ? nil : File.read(filename, :encoding => "UTF-8")

      # Ares welcome text
      client.emit_ooc t('client.welcome')

      # Game welcome text.
      welcome_text = connect_config['welcome_text']
      if (!welcome_text.nil?)
        client.emit_ooc welcome_text
      end
    end
  end
end

    
    
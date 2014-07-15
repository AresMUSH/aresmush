module AresMUSH
  module Mail
    

    def self.with_a_delivery(client, num, &block)
      if (num !~ /^[\d]+$/)
        client.emit_failure t('mail.invalid_message_number')
        return
      end
         
      index = num.to_i - 1
      if (index < 0) 
        client.emit_failure t('mail.invalid_message_number')
        return
      end
        
      if (client.char.mail.count <= index)
        client.emit_failure t('mail.invalid_message_number')
        return
      end
        
      yield client.char.mail[index]
    end
    
    def self.with_a_message(client, num, &block)
      Mail.with_a_delivery(client, num) do |delivery|
        yield delivery.message
      end
    end
    
  end
end
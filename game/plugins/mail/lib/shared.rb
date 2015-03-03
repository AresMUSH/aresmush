module AresMUSH
  module Mail
    def self.trashed_tag
      "Trash"
    end
    
    def self.sent_tag
      "Sent"
    end
    
    def self.inbox_tag
      "Inbox"
    end
    
    def self.archive_tag
      "Archive"
    end
    
    def self.with_a_delivery(client, num, &block)
      Mail.with_a_delivery_from_a_list client, num, client.char.mail, &block
    end
    
    def self.with_a_delivery_from_a_list(client, num, list, &block)
      if (!num.is_integer?)
        client.emit_failure t('mail.invalid_message_number')
        return
      end
         
      index = num.to_i - 1
      if (index < 0) 
        client.emit_failure t('mail.invalid_message_number')
        return
      end
        
      if (list.count <= index)
        client.emit_failure t('mail.invalid_message_number')
        return
      end
        
      yield list[index]
    end
    
    def self.with_a_message(client, num, &block)
      Mail.with_a_delivery(client, num) do |delivery|
        yield delivery.message
      end
    end
    
    def self.validate_recipients(names, client)
      names.each do |name|
        result = ClassTargetFinder.find(name, Character, client)
        if (!result.found?)
          client.emit_failure(t('mail.invalid_recipient', :name => name))
          return false
        end
        return true
      end
    end
    
    def self.is_composing_mail?(client)
      return false if client.char.nil?
      return false if client.char.mail_compose_to.nil?
      return false if client.char.mail_compose_to.empty?
      return true
    end
    
    def self.toss_composition(client)
      client.char.mail_compose_to = nil
      client.char.mail_compose_subject = nil
      client.char.mail_compose_body = nil
      client.char.save
    end
    
  end
end
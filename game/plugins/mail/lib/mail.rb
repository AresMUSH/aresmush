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
    
    def self.filtered_mail(client)
      filter = client.char.mail_filter || Mail.inbox_tag
      client.char.mail.select { |d| d.tags.include?(filter) }
    end
    
    def self.with_a_delivery(client, num, &block)
      list = Mail.filtered_mail(client)      
      Mail.with_a_delivery_from_a_list client, num, list, &block
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
    
    def self.empty_trash(client)
      Global.logger.debug "Emptying trash for #{client.char.name}."
      client.char.mail.each do |m|
        # DO NOT USE DESTROY here or it will force a reload of the clients 
        # for each deleted message.
        if (m.tags.include?(Mail.trashed_tag))          
          m.delete # Do not destroy - see note above
        end
      end
      # Reload clients only once.
      Global.client_monitor.reload_clients
    end
    
    def self.send_mail(names, subject, body, client)
      author = client.nil? ? Game.master.system_character : client.char
      
      recipients = []
      names.each do |name|
        result = ClassTargetFinder.find(name, Character, client)
        if (!result.found?)
          if (client)
            client.emit_failure(t('mail.invalid_recipient', :name => name))
          end
          return false
        end
        recipients << result.target
      end
      
      recipients << author if (author.copy_sent_mail && !recipients.include?(author))
      
      to_list = recipients.map { |r| r.name }.join(" ")
      
      recipients.each do |r|
        delivery = MailMessage.create(subject: subject, body: body, author: author, to_list: to_list, character: r)
        if (r == author)
          delivery.read = true
          if (author.copy_sent_mail)
            delivery.tags << Mail.sent_tag
          else
            delivery.tags << Mail.inbox_tag
          end
        else
          delivery.tags << Mail.inbox_tag
        end
        delivery.save
        
        receive_client = r.client
        if (receive_client && receive_client != client)
          receive_client.emit_ooc t('mail.new_mail', :from => author.name, :subject => subject)
        end
      end
      
      return true
    end
  end
end
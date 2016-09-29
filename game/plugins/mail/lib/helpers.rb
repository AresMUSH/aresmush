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
    
    def self.filtered_mail(char)
      filter = char.mail_filter || Mail.inbox_tag
      char.mail.select { |d| d.tags.include?(filter) }
    end
    
    def self.with_a_delivery(client, enactor, num, &block)
      list = Mail.filtered_mail(enactor)      
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
    
    def self.is_composing_mail?(char)
      return false if !char
      return false if !char.mail_compose_to
      return false if char.mail_compose_to.empty?
      return true
    end
    
    def self.toss_composition(char)
      char.mail_compose_to = nil
      char.mail_compose_subject = nil
      char.mail_compose_body = nil
      char.save
    end
    
    def self.empty_trash(char)
      Global.logger.debug "Emptying trash for #{char.name}."
      char.mail.each do |m|
        # DO NOT USE DESTROY here or it will force a reload of the clients 
        # for each deleted message.
        if (m.tags.include?(Mail.trashed_tag))          
          m.delete # Do not destroy - see note above
        end
      end
    end
    
    def self.send_mail(names, subject, body, client, author = nil)
      author = author || Game.master.system_character
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
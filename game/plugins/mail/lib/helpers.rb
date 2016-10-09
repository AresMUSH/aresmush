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
    
    def self.get_or_create_mail_prefs(char)
      prefs = char.mail_prefs
      if (!prefs)
        prefs = MailPrefs.create(character: char)
        char.update(mail_prefs: prefs)
      end
      prefs
    end
    
    def self.filtered_mail(char)
      prefs = Mail.get_or_create_mail_prefs(char)
      filter = prefs.mail_filter || Mail.inbox_tag
      char.mail.select { |d| d.tags && d.tags.include?(filter) }
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
              
      yield list.to_a[index]
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
      !!char.mail_composition
    end
    
    def self.toss_composition(char)
      return if !char.mail_composition
      char.mail_composition.delete
    end
    
    def self.empty_trash(char)
      Global.logger.debug "Emptying trash for #{char.name}."
      char.mail.each do |m|
        if (m.tags.include?(Mail.trashed_tag))          
          m.delete
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
      
      copy_sent = author.mail_prefs && author.mail_prefs.copy_sent_mail
      
      recipients << author if (copy_sent && !recipients.include?(author))
      
      to_list = recipients.map { |r| r.name }.join(" ")
      
      recipients.each do |r|
        delivery = MailMessage.create(subject: subject, body: body, author: author, to_list: to_list, character: r)
        tags = []
        if (r == author)
          delivery.read = true
          if (copy_sent)
            tags << Mail.sent_tag
          else
            tags << Mail.inbox_tag
          end
        else
          tags << Mail.inbox_tag
        end
        delivery.tags = tags
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
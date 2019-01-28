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
        
    def self.all_tags(char)
      all_tags = []
      char.mail.each do |msg|
        all_tags = all_tags.concat(msg.tags || [])
      end
      all_tags.uniq
    end
    
    def self.filtered_mail(char, filter = Mail.inbox_tag)
      if (filter.start_with?("review"))
        sent_to = Character.find_one_by_name(filter.after(" "))
        return char.sent_mail_to(sent_to)
      end
      
      messages = char.mail.select { |d| d.tags && d.tags.include?(filter) }
      messages.sort_by { |m| m.created_at }
    end
    
    def self.archive_delivery(delivery)
      tags = delivery.tags
      tags << Mail.archive_tag
      tags.delete(Mail.inbox_tag)
      tags.uniq!
      delivery.update(tags: tags)
    end
    
    def self.with_a_delivery(client, enactor, num, &block)
      list = Mail.filtered_mail(enactor, enactor.mail_filter)      
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
    
    def self.remove_from_trash(message)
      tags = message.tags
      tags.delete Mail.trashed_tag
      message.update(tags: tags)
    end
    
    def self.move_to_trash(message)
      tags = message.tags
      tags << Mail.trashed_tag
      message.update(tags: tags)
    end
    
    def self.reply_list(msg, enactor, reply_all = false)
      recipients = msg.author ? [msg.author.name ] : []
      if (reply_all)
        to_list = msg.to_list.split(" ")
        to_list.delete enactor.name
        recipients.concat to_list
      end
      recipients.uniq
    end
    
  end
end
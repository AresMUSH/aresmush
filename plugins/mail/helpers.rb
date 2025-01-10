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
    
    def self.start_marker
      Global.read_config('mail', 'start_marker') || '['
    end
    
    def self.end_marker
      Global.read_config('mail', 'end_marker') || ']'
    end
        
        
    def self.tag_sort_weight(tag)
      return 1 if tag == "Inbox"
      return 3 if tag == "Sent"
      return 4 if tag == "Archive"
      return 5 if tag == "Trash"
      return 2
    end
    
    def self.all_tags(char)
      all_tags = []
      char.mail.each do |msg|
        all_tags = all_tags.concat(msg.tags || [])
      end
      all_tags << "Archive"
      all_tags << "Trash"
      all_tags << "Sent"
      all_tags.uniq.sort_by { |t| [ Mail.tag_sort_weight(t), t ] }
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
    
    def self.empty_all_trash(char)
      Global.logger.debug "Emptying mail for #{char.name}"
      char.mail.each do |m|
        if (m.in_trash?)
            m.delete
        end
      end
      char.update(mail_trash_last_emptied: Time.now)      
    end
    
    def self.empty_old_trash(char)
      default_time = Time.new(1999)
      
      # Only need to empty trash once a week
      return if (Time.now - (char.mail_trash_last_emptied || default_time) < 7*86400)
        
      Global.logger.debug "Emptying mail for #{char.name}"
                  
      keep_message_time = 30*86400
      char.mail.each do |m|
        if (m.in_trash? && (Time.now - (m.trashed_time || default_time) > keep_message_time))
            m.delete
        end
      end
      
      char.update(mail_trash_last_emptied: Time.now)      
    end
    
    def self.remove_from_trash(message)
      tags = message.tags
      tags.delete Mail.trashed_tag
      message.update(tags: tags, trashed_time: nil)
    end
    
    def self.move_to_trash(message)
      tags = message.tags
      tags << Mail.trashed_tag
      message.update(tags: tags, trashed_time: Time.now)
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
    
    def self.mark_read(message)
      message.mark_read
      Login.mark_notices_read(message.character, :mail, message.id)
    end
    
    def self.select_message_range(range_param)
      if (range_param =~ /\-/)
        splits = range_param.split("-")
        if (splits.count != 2)
          return nil
        end
        start_message = splits[0].to_i
        end_message = splits[1].to_i
      
        if (start_message <= 0 || end_message <= 0 || start_message > end_message)
          return nil
        end
        (start_message..end_message).to_a.reverse
      else
        message = range_param.to_i
        if (message == 0)
          return nil
        end
          
        return [ message ]
      end
   end
    
  end
end
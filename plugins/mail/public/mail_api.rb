module AresMUSH
  module Mail
    
    def self.send_mail(names, subject, body, client, author = nil)
      author = author || Game.master.system_character
      recipients = []
      
      if author.has_any_role?("guest")
        if (client)
          client.emit_failure t('dispatcher.not_allowed') 
        end
        return false
      end
      
      names.each do |name|
        recipient = Character.find_one_by_name(name)
        if (!recipient)
          if (client)
            client.emit_failure(t('mail.invalid_recipient', :name => name))
          end
          return false
        end
        recipients << recipient
      end
      
      recipients << author
      recipients = recipients.uniq
      
      to_list = recipients.map { |r| r.name }.join(" ")
      notification = t('mail.new_mail', :from => author.name, :subject => subject)
      
      recipients.each do |r|
        delivery = MailMessage.create(subject: subject, body: body, author: author, to_list: to_list, character: r)
        tags = []
        if (r == author && !names.include?(author.name))
          delivery.update(read: true)
          tags << Mail.sent_tag
        else
          tags << Mail.inbox_tag
        end
        delivery.update(tags: tags)  
        Login.notify(r, :mail, notification, delivery.id)
      end
      
      Global.notifier.notify_ooc(:new_mail, notification) do |char|
         char && recipients.include?(char) && char != author
      end
      
      return true
    end
  end
end
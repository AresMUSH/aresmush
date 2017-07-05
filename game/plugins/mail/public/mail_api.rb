module AresMUSH
  module Mail
    
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
      
      copy_sent = author.copy_sent_mail
      
      recipients << author if copy_sent
      recipients = recipients.uniq
      
      to_list = recipients.map { |r| r.name }.join(" ")
      
      recipients.each do |r|
        delivery = MailMessage.create(subject: subject, body: body, author: author, to_list: to_list, character: r)
        tags = []
        if (r == author)
          delivery.update(read: true)
          if (copy_sent)
            tags << Mail.sent_tag
          else
            tags << Mail.inbox_tag
          end
        else
          tags << Mail.inbox_tag
        end
        delivery.update(tags: tags)
        
        receive_client = r.client
        if (r != author)
          if (receive_client)
            receive_client.emit_ooc t('mail.new_mail', :from => author.name, :subject => subject)
          end
          Global.client_monitor.notify_web_clients :new_mail, t('mail.web_new_mail', :subject => subject, :from => author.name), r
        end
      end
      return true
    end
  end
end
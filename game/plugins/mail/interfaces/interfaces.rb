module AresMUSH
  module Mail
    def self.send_mail(names, subject, body, client)
      author = client.nil? ? Game.master.system_character : client.char
      
      msg = MailMessage.new(subject: subject, 
        body: body, 
        author: author)

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
      
      msg.to_list = recipients.map { |r| r.name }.join(" ")
      msg.save
      
      recipients.each do |r|
        delivery = MailDelivery.create(message: msg, character: r)
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
          receive_client.emit_ooc t('mail.new_mail', :from => author.name, :subject => msg.subject)
        end
      end
      
      return true
    end
  end
end
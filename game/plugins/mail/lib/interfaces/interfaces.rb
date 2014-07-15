module AresMUSH
  module Mail
    def self.send_mail(names, subject, body, client)
      msg = MailMessage.create(subject: subject, 
        body: body, 
        author: client.char)

      recipients = []
      names.each do |name|
        result = ClassTargetFinder.find(name, Character, client)
        if (!result.found?)
          client.emit_failure(t('mail.invalid_recipient', :name => name))
          return false
        end
        recipients << result.target
      end
      
      recipients.each do |r|
        MailDelivery.create(message: msg, character: r)
        receive_client = Global.client_monitor.find_client(r)
        if (!receive_client.nil?)
          receive_client.emit_ooc t('mail.new_mail', :from => client.char.name, :subject => msg.subject)
        end
      end
      
      return true
    end
  end
end
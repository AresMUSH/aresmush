module AresMUSH
  
  class Character
    collection :mail, "AresMUSH::MailMessage"
    reference :mail_composition, "AresMUSH::MailComposition"
    attribute :mail_filter, :default => "Inbox"
    
    # Deprecated.  Sent mail is always on now.
    attribute :copy_sent_mail, :type => DataType::Boolean

    before_delete :delete_mail
    
    def has_unread_mail?
      !unread_mail.empty?
    end
    
    def num_unread_mail
      unread_mail.count
    end
    
    def delete_mail
      self.mail_composition.delete if self.mail_composition
      self.mail.each { |m| m.delete }
    end
    
    def unread_mail
      mail.except(read: true)
    end
    
    def sent_mail_to(recipient)
      recipient.mail.find(author_id: self.id)
    end
  end 
end
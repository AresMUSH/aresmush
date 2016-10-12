module AresMUSH
  
  class Character
    collection :mail, "AresMUSH::MailMessage"
    reference :mail_composition, "AresMUSH::MailComposition"
    reference :mail_prefs, "AresMUSH::MailPrefs"
    
    before_delete :delete_mail
    
    def delete_mail
      self.mail_prefs.delete if self.mail_prefs
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
  
  class MailPrefs < Ohm::Model
    include ObjectModel
    
    reference :character, "AresMUSH::Character"
    
    attribute :copy_sent_mail, :type => DataType::Boolean
    attribute :mail_filter, :default => "Inbox"
  end
  
  class MailComposition < Ohm::Model
    include ObjectModel
    
    attribute :subject
    attribute :body
    attribute :to_list, :type => DataType::Array
    
    reference :character, "AresMUSH::Character"
  end
  
    
  class MailMessage < Ohm::Model
    include ObjectModel
      
    reference :character, "AresMUSH::Character"
    reference :author, "AresMUSH::Character"

    attribute :subject
    attribute :body
    attribute :to_list
    
    attribute :read, :type => DataType::Boolean
    attribute :tags, :type => DataType::Array
    
    index :read
  end
end
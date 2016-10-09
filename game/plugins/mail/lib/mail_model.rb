module AresMUSH
  
  class Character
    collection :mail, "AresMUSH::MailMessage"
    reference :mail_composition, "AresMUSH::MailComposition"
    reference :mail_prefs, "AresMUSH::MailPrefs"
    
    before_delete :delete_mail
    
    def delete_mail
      mail.each { |m| m.delete }
    end
    
    def has_unread_mail?
      !unread_mail.empty?
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
    
    before_create :set_default_mail_attributes
    
    def set_default_mail_attributes
      self.mail_filter = "Inbox"
    end
    
    reference :character, "AresMUSH::Character"
    
    attribute :copy_sent_mail, DataType::Boolean
    attribute :mail_filter
  end
  
  class MailComposition < Ohm::Model
    include ObjectModel
    
    attribute :subject
    attribute :body
    attribute :to_list, DataType::Array
    
    reference :character, "AresMUSH::Character"
  end
  
    
  class MailMessage < Ohm::Model
    include ObjectModel
      
    reference :character, "AresMUSH::Character"
    reference :author, "AresMUSH::Character"

    attribute :subject
    attribute :body
    attribute :to_list
    
    attribute :read, DataType::Boolean
    attribute :tags, DataType::Array
    
    index :read
  end
end
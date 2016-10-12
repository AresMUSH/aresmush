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
    
    default_values :default_mail_attributes
    
    def self.default_mail_attributes
      { mail_filter: "Inbox" }
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
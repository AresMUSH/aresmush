module AresMUSH
  class Character
    collection :mail, "AresMUSH::MailMessage"
    attribute :copy_sent_mail, DataType::Boolean
    attribute :mail_filter

    reference :mail_composition, "AresMUSH::MailComposition"
    
    before_create :set_default_mail_attributes
    
    def set_default_mail_attributes
      self.mail_filter = "Inbox"
    end
    
    def has_unread_mail?
      mail.any? { |m| !m.read }
    end
    
    def unread_mail
      mail.select { |m| !m.read }
    end
    
    def sent_mail_to(recipient)
      mail.find(author_id: recipient.id)
    end
  end    
    
  class MailComposition < Ohm::Model
    include ObjectModel
    
    attribute :subject
    attribute :body
    
    reference :character, "AresMUSH::Character"
    
    set :to_list, "AresMUSH::Chracter"
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
  end
end
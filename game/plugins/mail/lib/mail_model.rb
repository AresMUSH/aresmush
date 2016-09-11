module AresMUSH
  class Character
    embeds_many :mail, :class_name => "AresMUSH::MailMessage", order: :created_at.asc
    
    field :mail_compose_subject, :type => String
    field :mail_compose_to, :type => Array
    field :mail_compose_body, :type => String
    field :copy_sent_mail, :type => Boolean, :default => false
    field :mail_filter, :type => String, :default => "Inbox"
    
    def has_unread_mail?
      mail.any? { |m| !m.read }
    end
    
    def unread_mail
      mail.select { |m| !m.read }
    end
    
    def sent_mail_to(recipient)
      mail.where(author: recipient)
    end
  end    
    
  class MailMessage
    include SupportingObjectModel
      
    embedded_in :character, :inverse_of => :mail
    belongs_to :author, :class_name => "AresMUSH::Character", :inverse_of => nil

    field :subject, :type => String
    field :body, :type => String
    field :to_list, :type => String
    
    
    field :read, :type => Boolean  
    field :tags, :type => Array, :default => []
  end
end
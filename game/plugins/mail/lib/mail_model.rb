module AresMUSH
  class Character
    has_many :sent_mail, :class_name => "AresMUSH::MailMessage", :inverse_of => 'author', order: :created_at.asc
    has_many :mail, :class_name => "AresMUSH::MailDelivery", :inverse_of => 'character', order: :created_at.asc, :dependent => :destroy
    field :mail_compose_subject, :type => String
    field :mail_compose_to, :type => Array
    field :mail_compose_body, :type => String
    field :copy_sent_mail, :type => Boolean, :default => false
    field :mail_filter, :type => String, :default => "Inbox"
    
    def unread_mail
      mail.select { |m| !m.read }
    end
  end
    
  class MailMessage
    include SupportingObjectModel
    
    field :subject, :type => String
    field :body, :type => String
    field :to_list, :type => String
    
    belongs_to :author, :class_name => "AresMUSH::Character", :inverse_of => 'sent_mail'    
    has_many :mail_deliveries, :inverse_of => 'message'
  end
    
  class MailDelivery
    include SupportingObjectModel
      
    belongs_to :character, :inverse_of => :mail
    belongs_to :message, :class_name => "AresMUSH::MailMessage"
      
    field :read, :type => Boolean  
    field :tags, :type => Array, :default => []
  end
end
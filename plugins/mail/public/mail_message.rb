module AresMUSH
  class MailThread < Ohm::Model
    include ObjectModel
    
    collection :messages, "AresMUSH::MailMessage", :thread
    
    def messages_for(enactor)
      self.messages.select { |m| m.character == enactor }.sort_by { |m| m.created_at }
    end
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
    
    reference :thread, "AresMUSH::MailThread"
    
    index :read
    
    def mark_read
      self.update(read: true)
    end
    
    def author_name
      !self.author ? t('global.deleted_character') : self.author.name
    end
    
    def created_date_str(viewer)
      OOCTime.local_short_timestr(viewer, self.created_at)
    end
    
    def thread_messages(enactor)
      return [] if !self.thread
      self.thread.messages_for(enactor)
    end
  end
end
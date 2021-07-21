module AresMUSH
  class MailMessage < Ohm::Model
    include ObjectModel
      
    reference :character, "AresMUSH::Character"
    reference :author, "AresMUSH::Character"

    attribute :subject
    attribute :body
    attribute :to_list
    
    attribute :read, :type => DataType::Boolean
    attribute :tags, :type => DataType::Array
    
    reference :thread, "AresMUSH::MailMessage"
    
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
    
    def find_replies(enactor)
      thread_id = self.thread ? self.thread.id : self.id
      enactor.mail.find(thread_id: thread_id).to_a.sort_by { |m| m.created_at }
    end
    
    def is_reply?
      !!self.thread
    end
    
    
  end
end
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
  end
end
module AresMUSH
  class PageMessage < Ohm::Model
    include ObjectModel
    
    reference :character, "AresMUSH::Character"
    reference :author, "AresMUSH::Character"
    
    attribute :thread_name
    attribute :message
    attribute :is_read, :type => DataType::Boolean
    
    def is_read?
      self.is_read
    end
    
    def is_unread?
      !self.is_read
    end
  end
end
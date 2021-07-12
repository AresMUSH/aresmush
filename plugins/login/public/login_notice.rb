module AresMUSH
  class LoginNotice < Ohm::Model
    include ObjectModel
    attribute :type
    attribute :message
    attribute :data
    attribute :reference_id
    attribute :is_unread, :type => DataType::Boolean, :default => true
    attribute :timestamp, :type => DataType::Time
    
    reference :character, "AresMUSH::Character"
    index :is_unread
    
    def is_unread?
      self.is_unread
    end
    
    def can_view?(viewer)
      AresCentral.is_alt?(viewer, self.character)
    end
  end
end
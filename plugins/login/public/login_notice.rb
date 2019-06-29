module AresMUSH
  class LoginNotice < Ohm::Model
    include ObjectModel
    attribute :type
    attribute :message
    attribute :data
    attribute :is_unread, :type => DataType::Boolean, :default => true
    
    reference :character, "AresMUSH::Character"
    index :is_unread
  end
end
module AresMUSH  
  class MailComposition < Ohm::Model
    include ObjectModel
    
    attribute :subject
    attribute :body
    attribute :to_list, :type => DataType::Array
    
    reference :character, "AresMUSH::Character"
  end    
end
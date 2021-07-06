module AresMUSH
  class ContentTag < Ohm::Model
    include ObjectModel

    attribute :name    
    attribute :content_id
    attribute :content_type
    
    index :name
    index :content_type
    index :content_id
  end
end

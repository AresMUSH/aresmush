module AresMUSH
  class ContentTag < Ohm::Model
    include ObjectModel

    attribute :name    
    attribute :content_id
    attribute :content_type
    
    index :name
    index :content_type
    index :content_id
    
    def self.find_by_model(model)
      type = model.class.to_s
      id = model.id.to_s
      ContentTag.find(content_type: type, content_id: id)
    end
  end
end

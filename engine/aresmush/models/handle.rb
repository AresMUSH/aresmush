module AresMUSH
  class Handle < Ohm::Model
    include ObjectModel
    include FindByName
    
    attribute :name
    attribute :handle_id
    attribute :name_upcase
    
    attribute :friends, :type => DataType::Array
    
    index :name_upcase
    index :handle_id
    
    reference :character, "AresMUSH::Character"
    
    before_save :save_upcase
    
    def save_upcase
      self.name_upcase = self.name ? self.name.upcase : nil
    end
    
  end
end
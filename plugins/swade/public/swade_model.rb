module AresMUSH
  class Character < Ohm::Model
    collection :Swade_attributes, "AresMUSH::SwadeAttribute"
    
    before_delete :delete_Swade_abilities
    
    def delete_Swade_abilities
      [ self.Swade_attributes ].each do |list|
        list.each do |a|
          a.delete
        end
      end
    end
  end
  
  class SwadeAttribute < Ohm::Model
    include ObjectModel
    
    attribute :name
    attribute :die_step
    reference :character, "AresMUSH::Character"
    index :name
  end
  
end
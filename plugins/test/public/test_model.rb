module AresMUSH
  class Character < Ohm::Model
    collection :test_attributes, "AresMUSH::testAttribute"
    
    before_delete :delete_test_abilities
    
    def delete_test_abilities
      [ self.test_attributes ].each do |list|
        list.each do |a|
          a.delete
        end
      end
    end
  end
  
  class TestAttribute < Ohm::Model
    include ObjectModel
    
    attribute :name
    attribute :die_step
    reference :character, "AresMUSH::Character"
    index :name
  end
  
end
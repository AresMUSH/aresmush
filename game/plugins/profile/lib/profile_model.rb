module AresMUSH
  class Character
    collection :profile_fields, "AresMUSH::ProfileField"
    
    before_delete :delete_all_profiles
    
    def delete_all_profiles
      self.profile_fields.each { |p| p.delete }
    end
  end
  
  class ProfileField < Ohm::Model
    include ObjectModel
    
    attribute :name
    attribute :data
    reference :character, "AresMUSH::Character"
    
    index :name
  end
end
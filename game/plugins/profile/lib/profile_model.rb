module AresMUSH
  class Character
    collection :profile, "AresMUSH::ProfileField"
  end
  
  class ProfileField < Ohm::Model
    include ObjectModel
    
    attribute :name
    attribute :data
    reference :character, "AresMUSH::Character"
  end
end
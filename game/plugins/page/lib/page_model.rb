module AresMUSH
  class Character
    reference :page_prefs, "AresMUSH::PagePrefs"
  end
  
  class PagePrefs < Ohm::Model
    include ObjectModel
    
    reference :character, "AresMUSH::Character"
    
    attribute :last_paged, DataType::Array
    attribute :do_not_disturb, DataType::Boolean
  end
end
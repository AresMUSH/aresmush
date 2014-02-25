module AresMUSH
  class Character
    key :description, String
    key :glance, String
  end
  
  class Room
    key :description, String
  end
  
  class Exit
    key :description, String
  end  
end
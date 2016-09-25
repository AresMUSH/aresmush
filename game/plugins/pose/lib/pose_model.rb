module AresMUSH
  class Character
    field :nospoof, :type => Boolean, :default => false
    field :autospace, :type => String, :default => "%r"    
  end
  
  class Room
    field :repose_on, :type => Boolean, :default => true
    field :poses, :type => Array, :default => []
  end
end
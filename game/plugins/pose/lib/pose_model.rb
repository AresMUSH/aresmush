module AresMUSH
  class Character
    field :nospoof, :type => Boolean, :default => false
    field :autospace, :type => String, :default => "%r"    
  end
end
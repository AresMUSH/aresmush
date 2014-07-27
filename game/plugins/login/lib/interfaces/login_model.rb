module AresMUSH
  class Character
    field :email, :type => String
    field :terms_of_service_acknowledged, :type => Time
    field :watch, :type => String, :default => "all"
  end  
end
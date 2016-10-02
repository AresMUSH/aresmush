module AresMUSH
  class Character
    attribute :cookie_count, DataType::Integer
    
    set :cookies_received, "AresMUSH::Character"
    set :cookies_given, "AresMUSH::Character"
  end
end
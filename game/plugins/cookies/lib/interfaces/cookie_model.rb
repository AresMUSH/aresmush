module AresMUSH
  class Character
    field :cookie_count, :type => Integer, :default => 0
    has_and_belongs_to_many :cookies_received, :class_name => 'AresMUSH::Character', :inverse_of => :cookies_given
    has_and_belongs_to_many :cookies_given, :class_name => 'AresMUSH::Character', :inverse_of => :cookies_received
  end
end
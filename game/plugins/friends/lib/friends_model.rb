module AresMUSH
  class Character
    has_many :friendships, :inverse_of => :character, :dependent => :destroy
    has_many :friends_of, :class_name => 'AresMUSH::Friendship', :inverse_of => :friend, :dependent => :destroy
  end  
  
  class Friendship
    include SupportingObjectModel
    
    belongs_to :character, :inverse_of => :friendships
    belongs_to :friend, :class_name => 'AresMUSH::Character', :foreign_key =>'friend_id', :inverse_of => :friends_of
    
    field :note, :type => String
  end
end
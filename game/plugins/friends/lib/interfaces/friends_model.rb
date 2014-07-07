module AresMUSH
  class Character
    has_many :friendships, :inverse_of => :character, :dependent => :destroy
    has_many :friends_of, :class_name => 'AresMUSH::Friendship', :inverse_of => :friend, :dependent => :destroy
    
    
    def friends
      friendships.map { |f| f.friend }
    end
  end  
  
  class Friendship
    include Mongoid::Document
    
    belongs_to :character, :inverse_of => :friendships
    belongs_to :friend, :class_name => 'AresMUSH::Character', :foreign_key =>'friend_id', :inverse_of => :friends_of
    after_save :reload_clients
    
    def reload_clients
      Global.client_monitor.reload_clients
    end
  end
end
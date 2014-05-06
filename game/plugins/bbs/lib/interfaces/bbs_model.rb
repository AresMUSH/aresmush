module AresMUSH
  class Character
    field :read_posts, :type => Array, :default => []

    has_many :authored_posts, :class_name => 'AresMUSH::BbsPost', :inverse_of => 'author'
    has_many :read_posts, :class_name => 'AresMUSH::BbsPost', :inverse_of => nil
  end
  
  class BbsBoard
    include ObjectModel
    
    field :description, :type => String
    field :read_roles, :type => Array, :default => []
    field :write_roles, :type => Array, :default => []
    
    has_many :bbs_posts
    
    def has_unread?(char)
      # TODO TODO
      true
    end
    
    def self.all_sorted
      BbsBoard.all.sort { |b1, b2| b1.name <=> b2.name }
    end
  end
  
  class BbsPost
    include Mongoid::Document
    
    field :subject, :type => String
    field :message, :type => String
    field :replies, :type => Array
    
    belongs_to :bbs_board
    belongs_to :author, :class_name => "AresMUSH::Character", :inverse_of => 'authored_posts'
    
    def is_unread?(char)
      # TODO TODO
      true
    end
  end
end

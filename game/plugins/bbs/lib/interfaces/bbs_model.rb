module AresMUSH
  class Character
    field :read_posts, :type => Array, :default => []

    has_many :authored_posts, :class_name => 'AresMUSH::BbsPost', :inverse_of => 'author'
  end
  
  class BbsBoard
    include ObjectModel
    
    field :description, :type => String
    field :read_roles, :type => Array, :default => []
    field :write_roles, :type => Array, :default => []
    
    has_many :bbs_posts, order: :created_at.asc, :dependent => :delete
    
    def has_unread?(char)
      bbs_posts.each.any? { |p| p.is_unread?(char) }
    end
    
    def self.all_sorted
      BbsBoard.all.sort { |b1, b2| b1.name <=> b2.name }
    end
  end
  
  class BbsPost
    include Mongoid::Document
    include Mongoid::Timestamps
    
    field :subject, :type => String
    field :message, :type => String
    field :replies, :type => Array
    
    belongs_to :bbs_board
    belongs_to :author, :class_name => "AresMUSH::Character", :inverse_of => 'authored_posts'
    
    def is_unread?(char)
      !char.read_posts.include?(self.id)
    end
    
    # Don't forget to save afterward!
    def mark_read(char)
      char.read_posts << self.id
    end

  end
end

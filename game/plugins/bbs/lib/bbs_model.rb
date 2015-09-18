module AresMUSH
  class Character
    has_many :authored_bbposts, :class_name => 'AresMUSH::BbsPost', :inverse_of => :author
    has_many :bbs_replies
  end
  
  class BbsBoard
    include SupportingObjectModel
        
    field :name, :type => String
    field :description, :type => String
    field :read_roles, :type => Array, :default => []
    field :write_roles, :type => Array, :default => []
    field :order, :type => Integer
    
    has_many :bbs_posts, order: :created_at.asc, :dependent => :destroy
    
    def has_unread?(char)
      bbs_posts.any? { |p| p.is_unread?(char) }
    end
    
    def self.all_sorted
      BbsBoard.all.sort { |a, b| [a.order, a.name] <=> [b.order, b.name] }
    end
    
    def first_unread(char)
      all_unread = bbs_posts.select { |p| p.is_unread?(char) }
      all_unread.first
    end
  end
  
  class BbsPost
    include SupportingObjectModel
    
    field :subject, :type => String
    field :message, :type => String
    
    belongs_to :bbs_board
    belongs_to :author, :class_name => "AresMUSH::Character", :inverse_of => :authored_bbposts
    
    has_and_belongs_to_many :readers, :class_name => "AresMUSH::Character", :inverse_of => nil
    has_many :bbs_replies, order: :created_at.asc, :dependent => :destroy
    
    def is_unread?(char)
      !readers.include?(char)
    end
    
    def mark_read(char)
      readers << char
      save!
    end
    
    def mark_unread
      readers.clear
      save!
    end
  end
  
  class BbsReply
    include SupportingObjectModel
    
    belongs_to :bbs_post
    belongs_to :author, :class_name => "AresMUSH::Character", :inverse_of => 'authored_replies'
    
    field :message, :type => String
  end
end

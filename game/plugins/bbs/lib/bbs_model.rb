module AresMUSH
  class BbsBoard
    include SupportingObjectModel
        
    field :name, :type => String
    field :description, :type => String
    field :read_roles, :type => Array, :default => []
    field :write_roles, :type => Array, :default => []
    field :order, :type => Integer
    
    embeds_many :bbs_posts, order: :created_at.asc
    
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
    
    embedded_in :bbs_board
    
    belongs_to :author, :class_name => "AresMUSH::Character"
    has_and_belongs_to_many :readers, :class_name => "AresMUSH::Character", :inverse_of => nil
    embeds_many :bbs_replies, order: :created_at.asc
    
    def authored_by?(char)
      char == author
    end
    
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
    
    def reference_str
      "(#{board_index}/#{post_index})"
    end
    
    def post_index
      self.bbs_board.bbs_posts.index(self) + 1
    end
    
    def board_index
      BbsBoard.all_sorted.index(self.bbs_board) + 1
    end
  end
  
  class BbsReply
    include SupportingObjectModel
    
    field :message, :type => String
    
    embedded_in :bbs_post
    belongs_to :author, :class_name => "AresMUSH::Character"
  end
end

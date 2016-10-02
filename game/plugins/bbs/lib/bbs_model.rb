module AresMUSH
  
  class Character
    def has_unread_bbs?
      BbsBoard.all.any? { |b| b.has_unread?(self) }
    end
  end
  
  class BbsBoard < Ohm::Model
    include ObjectModel

    attribute :name
    attribute :description
    attribute :order, DataType::Integer

    index :order
    index :name
    
    set :read_roles, "AresMUSH::Role"
    set :write_roles, "AresMUSH::Role"
    
    collection :bbs_posts, "AresMUSH::BbsPost"
    
    def has_unread?(char)
      bbs_posts.select { |p| p.is_unread?(char) }.any?
    end
    
    def self.all_sorted
      BbsBoard.all.sort_by(:order)
    end
    
    def first_unread(char)
      all_unread = bbs_posts.select { |p| p.is_unread?(char) }
      all_unread.first
    end
  end
  
  class BbsPost < Ohm::Model
    include ObjectModel
    
    attribute :subject
    attribute :message

    set :readers, "AresMUSH::Character"
        
    reference :author, "AresMUSH::Character"
    reference :bbs_board, "AresMUSH::BBsBoard"
    collection :bbs_replies, "AresMUSH::BbsReply"
    
    def authored_by?(char)
      char == author
    end
    
    def is_unread?(char)
      !readers.include?(char)
    end
    
    def mark_read(char)
      readers << char
      save
    end
    
    def mark_unread
      readers.clear
      save
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
  
  class BbsReply < Ohm::Model
    include ObjectModel
    
    attribute :message

    reference :bbs_post, "AresMUSH::BbsPost"
    reference :author, "AresMUSH::Character"
  end
end

module AresMUSH
  
  class Character
    def has_unread_bbs?
      BbsBoard.all.each do |b|
        if (b.has_unread?(self))
          return true
        end
      end
      return false
    end
    
    collection :bbs_read_marks, "AresMUSH::BbsReadMark"
  end
  
  class BbsReadMark < Ohm::Model
    include ObjectModel
    
    reference :bbs_post, "AresMUSH::BbsPost"
    reference :character, "AresMUSH::Character"
  end
  
  class BbsBoard < Ohm::Model
    include ObjectModel
    include FindByName

    attribute :name
    attribute :name_upcase
    attribute :description
    attribute :order, DataType::Integer

    index :order
    index :name_upcase
    
    set :read_roles, "AresMUSH::Role"
    set :write_roles, "AresMUSH::Role"
    
    collection :bbs_posts, "AresMUSH::BbsPost"
    
    before_save :set_upcase_name
    before_delete :delete_posts
    
    def delete_posts
      bbs_posts.each { |p| p.delete }
    end
      
    def set_upcase_name
      self.name_upcase = self.name.upcase
    end
    
    def unread_posts(char)
      return [] if !Bbs.can_read_board?(char, self)
      read_posts = char.bbs_read_marks.map { |m| m.bbs_post }
      bbs_posts.select { |p| !read_posts.include?(p) }
    end
      
    def has_unread?(char)
      !unread_posts(char).empty?
    end
    
    def self.all_sorted
      BbsBoard.all.sort_by(:order)
    end
    
    def first_unread(char)
      unread_posts(char).first
    end
  end
  
  class BbsPost < Ohm::Model
    include ObjectModel
    
    attribute :subject
    attribute :message
        
    reference :author, "AresMUSH::Character"
    reference :bbs_board, "AresMUSH::BbsBoard"
    collection :bbs_replies, "AresMUSH::BbsReply"
    
    index :bbs_board
    
    before_delete :delete_replies
    
    def delete_replies
      bbs_replies.each { |r| r.delete }
    end
    
    def authored_by?(char)
      char == author
    end
    
    def read_marker(char)
      BbsReadMark.find(character_id: char.id).combine(bbs_post_id: self.id).first
    end
    
    def is_unread?(char)
      !read_marker(char)
    end
    
    def mark_read(char)
      if (!read_marker(char))
        BbsReadMark.create(character: char, bbs_post: self)
      end
    end
    
    def mark_unread
      BbsReadMark.find(bbs_post_id: self.id).each { |rm| rm.delete }
    end
    
    def reference_str
      "(#{board_index}/#{post_index})"
    end
    
    def post_index
      self.bbs_board.bbs_posts.to_a.index(self) + 1
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

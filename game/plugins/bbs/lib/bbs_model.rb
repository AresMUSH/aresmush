module AresMUSH
  class BbsBoard < Ohm::Model
    include ObjectModel
    include FindByName

    attribute :name
    attribute :name_upcase
    attribute :description
    attribute :order, :type => DataType::Integer

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
      bbs_posts.select { |p| p.is_unread?(char) }
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
    
    def board_index
      BbsBoard.all_sorted.index(self) + 1
    end
  end
  
  class BbsPost < Ohm::Model
    include ObjectModel
    
    attribute :subject
    attribute :message
        
    reference :author, "AresMUSH::Character"
    reference :bbs_board, "AresMUSH::BbsBoard"
    collection :bbs_replies, "AresMUSH::BbsReply"
    set :readers, "AresMUSH::Character"
    
    index :bbs_board
    
    before_delete :delete_replies
    
    def delete_replies
      bbs_replies.each { |r| r.delete }
    end
    
    def authored_by?(char)
      char == author
    end
    
    def author_name
      !self.author ? t('bbs.deleted_author') : self.author.name
    end
    
    def is_unread?(char)
      !readers.include?(char)
    end
    
    def mark_read(char)
      readers.add char
    end
    
    def mark_unread
      readers.each { |r| readers.delete r }
    end
    
    def reference_str
      "(#{board_index}/#{post_index})"
    end
    
    def post_index
      self.bbs_board.bbs_posts.to_a.index(self) + 1
    end
    
    def board_index
      self.bbs_board.board_index
    end
    
    def created_date_str(char)
      OOCTime::Api.local_long_timestr(char, self.created_at)
    end
    
    def created_date_str_short(char)
      OOCTime::Api.local_short_timestr(char, self.created_at)
    end
  end
  
  class BbsReply < Ohm::Model
    include ObjectModel
    
    attribute :message

    reference :bbs_post, "AresMUSH::BbsPost"
    reference :author, "AresMUSH::Character"
    
    def authored_by?(char)
      char == author
    end
    
    def author_name
      !self.author ? t('bbs.deleted_author') : self.author.name
    end
    
    def created_date_str(char)
      OOCTime::Api.local_long_timestr(char, self.created_at)
    end    
  end
end

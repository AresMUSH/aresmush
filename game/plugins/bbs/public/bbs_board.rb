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
end

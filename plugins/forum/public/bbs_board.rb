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
      
    def sorted_posts
      bbs_posts.to_a.sort_by { |p| [ p.is_pinned? ? 0 : 1, p.created_at ] }
    end
    
    def set_upcase_name
      self.name_upcase = self.name.upcase
    end
    
    def last_post
      self.sorted_posts[-1]
    end
    
    def unread_posts(char)
      return [] if Forum.is_category_hidden?(char, self)
      return [] if !Forum.can_read_category?(char, self)
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
    
    def category_index
      BbsBoard.all_sorted.index(self) + 1
    end
    
    def last_post_with_activity
      return nil if self.bbs_posts.empty?
      
      sorted_posts = self.bbs_posts.to_a.sort_by { |p| p.last_updated }
      sorted_posts[-1]
    end
    
    def set_roles(role_names, role_type)
      role_list = role_type == :read ? self.read_roles : self.write_roles
      new_roles = []
      role_names.each do |r|
        role = Role.find_one_by_name(r)
        if (role)
          new_roles << role
        end
      end
      role_list.replace new_roles
    end
  end
end

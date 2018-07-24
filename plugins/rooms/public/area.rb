module AresMUSH
  class Area < Ohm::Model
    include ObjectModel
    include FindByName
    
    attribute :name
    attribute :name_upcase
    attribute :description
  
    index :name_upcase
    
    collection :rooms, "AresMUSH::Room"
    collection :children, "AresMUSH::Area", :parent
    
    reference :map, "AresMUSH::GameMap"
    reference :parent, "AresMUSH::Area"
    
    before_save :save_upcase
    
    def sorted_children
      children.to_a.sort_by { |a| a.name }
    end
    
    def save_upcase
      self.name_upcase = self.name ? self.name.upcase : nil
    end
    
    def search_blob
      rooms = self.rooms.map { |r| "#{r.name} #{r.description}"}.join(" ")
      parent_name = self.parent ? self.parent.name : ''
      "#{self.name} #{self.description} #{parent_name} #{rooms}"
    end
    
    def searchable?
      true
    end
    
    def search_name
      self.name
    end
    
    def search_summary
      self.description
    end
  end
end


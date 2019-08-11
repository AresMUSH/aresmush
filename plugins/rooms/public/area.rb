module AresMUSH
  class Area < Ohm::Model
    include ObjectModel
    include FindByName
    
    attribute :name
    attribute :name_upcase
    attribute :description
    attribute :summary
  
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
    
    def full_name
      self.parent ? "#{self.parent.full_name} - #{self.name}" : self.name
    end
  end
end


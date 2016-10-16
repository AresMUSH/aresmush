module AresMUSH
  class Npc < Ohm::Model
    include ObjectModel
    
    attribute :name
    attribute :name_upcase
    
    reference :combat, "AresMUSH::Combat"
    
    before_save :save_upcase
    before_delete :clear_damage
    collection :damage, "AresMUSH::Damage"
    
    def save
      self.name_upcase = self.name ? self.name.upcase : ""
    end
    
    def clear_damage
      self.damage.each { |d| d.delete }
    end
  end
end
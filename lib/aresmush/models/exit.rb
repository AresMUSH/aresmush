module AresMUSH
  class Exit < Ohm::Model
    include ObjectModel
    include FindByName
    
    attribute :name
    attribute :name_upcase
  
    index :name_upcase
    
    reference :source, "AresMUSH::Exit"
    reference :dest, "AresMUSH::Exit"
    
    # -----------------------------------
    # CLASS METHODS
    # -----------------------------------
  
    # Derived classes may implement name checking
    def self.check_name(name)
      nil
    end

    # -----------------------------------
    # INSTANCE METHODS
    # -----------------------------------
    
    def save
      self.name_upcase = self.name ? self.name.upcase : nil
      super
    end
    
  end
end

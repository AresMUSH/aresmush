module AresMUSH
  class Exit < Ohm::Model
    include ObjectModel
    include FindByName
    
    attribute :name
    attribute :name_upcase
  
    index :name_upcase
    
    reference :source, "AresMUSH::Room"
    reference :dest, "AresMUSH::Room"
    
    before_save :save_upcase
    
    # -----------------------------------
    # CLASS METHODS
    # -----------------------------------
  
    # Derived classes may implement name checking
    def self.check_name(name)
      nil
    end
    
    def self.dbref_prefix
      "E"
    end
    
    # -----------------------------------
    # INSTANCE METHODS
    # -----------------------------------
    
    def save_upcase
      self.name_upcase = self.name ? self.name.upcase : nil
    end
    
  end
end

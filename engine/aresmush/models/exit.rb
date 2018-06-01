module AresMUSH
  class Exit < Ohm::Model
    include ObjectModel
    include FindByName
    
    attribute :name
    attribute :name_upcase

    attribute :alias
    attribute :alias_upcase
  
    index :name_upcase
    
    reference :source, "AresMUSH::Room"
    reference :dest, "AresMUSH::Room"
    
    before_save :save_upcase
    
    # -----------------------------------
    # CLASS METHODS
    # -----------------------------------
  
    # The engine doesn't enforce name checking, but the a plugin can override this.
    # Just be sure not to have multiple plugins trying to redefine this same method.
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
      self.alias_upcase = self.alias ? self.alias.upcase : nil
    end
    
  end
end

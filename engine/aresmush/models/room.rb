module AresMUSH
  class Room < Ohm::Model
    include ObjectModel
    include FindByName
    
    attribute :name
    attribute :name_upcase

    index :name_upcase
  
    collection :exits, "AresMUSH::Exit", :source
    collection :exits_in, "AresMUSH::Exit", :dest
    collection :characters, "AresMUSH::Character"
    
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
      "R"
    end
    
    # -----------------------------------
    # INSTANCE METHODS
    # -----------------------------------
    
    def save_upcase
      self.name_upcase = self.name ? self.name.upcase : nil
    end

    def out_exit
      out = get_exit("O")
      return out if out
      out = get_exit("OUT")
      return out
    end
    
    def has_exit?(name)
      !get_exit(name).nil?
    end
    
    def get_exit(name)
      match = exits.select { |e| e.name_upcase == name.upcase }.first
      if (!match)
        match = exits.select { |e| e.alias_upcase == name.upcase }.first
      end
      match
    end
    
    # The way out; will be one named "O" or "Out" OR the first exit
    def way_out
      out = get_exit("O")
      return out if out
      return nil if exits.empty?
      return exits.first
    end
    
    # The way in; only applicable if the room has an out exit.
    def way_in
      o = out_exit
      return nil if !o
      ways_in = Exit.find(source_id: o.dest.id).combine(dest_id: self.id)
      return nil if ways_in.count != 1
      return ways_in.first
    end
  end
end

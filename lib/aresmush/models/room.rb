module AresMUSH
  class Room < Ohm::Model
    include ObjectModel
    include FindByName
    
    attribute :name
    attribute :name_upcase

    # TODO - MOVE
    attribute :repose_on
    attribute :description
    
    index :name_upcase
  
    collection :exits, "AresMUSH::Exit"
    collection :characters, "AresMUSH::Character"
    
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
    
    def delete
      sources = Exit.find(dest_id: self.id)
      sources.each do |s|
        s.dest = nil
        s.save
      end
      super
    end

    def out_exit
      out = get_exit("O")
      return out if out
      out = get_exit("OUT")
      return out
    end
    
    def clients
      Global.client_monitor.logged_in.select { |client, char| char.room == self }.keys
    end
    
    def emit(msg)
      clients.each { |c| c.emit(msg) }
    end
    
    def emit_ooc(msg)
      clients.each { |c| c.emit_ooc(msg) }
    end
        
    def has_exit?(name)
      !get_exit(name).nil?
    end
    
    def get_exit(name)
      match = exits.select { |e| e.name_upcase == name.upcase }.first
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

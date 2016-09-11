module AresMUSH
  class Room
    include ObjectModel

    has_many :exits, :class_name => 'AresMUSH::Exit', :foreign_key => :source_id, :inverse_of => "source_id", :dependent => :destroy
    has_many :characters, :class_name => 'AresMUSH::Character', :inverse_of => "room"

    register_default_indexes
    
    before_destroy :null_out_sources
     
    def null_out_sources
      sources = Exit.where(:dest_id => self.id)
      sources.each do |s|
        s.dest = nil
        s.save!
      end
    end
    
    def out_exit
      out = get_exit("O")
      return out if out
      out = get_exit("OUT")
      return out
    end
    
    def serializable_hash(options={})
      hash = super(options)
      hash[:exits] = exits.map { |e| e.id }
      hash[:characters] = characters.map { |c| c.id }
      hash
    end
    
    def clients
      clients = Global.client_monitor.logged_in_clients
      clients.select { |c| c.room == self }
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
      return out if !out.nil?
      return nil if exits.empty?
      return exits.first
    end
    
    # The way in; only applicable if the room has an out exit.
    def way_in
      o = out_exit
      return nil if !o
      ways_in = Exit.all_of(source: o.dest, dest: self).all
      return nil if ways_in.count != 1
      return ways_in.first
    end
  end
end

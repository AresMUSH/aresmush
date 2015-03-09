module AresMUSH
  
  class Game
    belongs_to :welcome_room, :class_name => "AresMUSH::Room", :inverse_of => nil
    belongs_to :ic_start_room, :class_name => "AresMUSH::Room", :inverse_of => nil
    belongs_to :ooc_room, :class_name => "AresMUSH::Room", :inverse_of => nil
        
    def is_special_room?(room)
      return true if room == welcome_room
      return true if room == ic_start_room
      return true if room == ooc_room
      return false
    end
  end
  
  
  class Room    
    field :area, :type => String
    field :grid_x, :type => String
    field :grid_y, :type => String
    field :room_type, :type => String, :default => "IC"
    field :is_foyer, :type => Boolean      
    
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
  
  class Exit
    def allow_passage?(char)
      return (self.lock_keys.empty? || char.has_any_role?(self.lock_keys))
    end
  end
end
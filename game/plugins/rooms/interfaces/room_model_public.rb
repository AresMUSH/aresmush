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
    
    def out_exit
      out = get_exit("O")
      return out if !out.nil?
      return nil if exits.empty?
      return exits.first
    end
  end
end
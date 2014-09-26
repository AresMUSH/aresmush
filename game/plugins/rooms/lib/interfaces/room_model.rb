module AresMUSH
  
  class Game
    field :welcome_room_id, :type => Moped::BSON::ObjectId
    field :ic_start_room_id, :type => Moped::BSON::ObjectId
    field :ooc_room_id, :type => Moped::BSON::ObjectId
        
    before_create :create_starting_rooms
    
    def welcome_room
      Room.find(self.welcome_room_id)
    end
    
    def ic_start_room
      Room.find(self.ic_start_room_id)
    end
    
    def ooc_room
      Room.find(self.ooc_room_id)
    end
    
    def create_starting_rooms  
      Global.logger.debug "Creating start rooms."
      
      welcome_room = AresMUSH::Room.create(:name => "Welcome Room", :room_type => "OOC")
      ic_start_room = AresMUSH::Room.create(:name => "IC Start", :room_type => "IC")
      ooc_room = AresMUSH::Room.create(:name => "OOC Center", :room_type => "OOC")
      
      self.welcome_room_id = welcome_room.id
      self.ic_start_room_id = ic_start_room.id
      self.ooc_room_id = ooc_room.id
    end
    
    def is_special_room?(room)
      return true if room == welcome_room
      return true if room == ic_start_room
      return true if room == ooc_room
      return false
    end
  end
  
  class Character
    before_create :set_starting_room
    
    def set_starting_room
      Global.logger.debug "Setting starting room."
      
      self.room = Game.master.welcome_room
    end
  end
  
  class Room    
    field :area, :type => String
    field :grid_x, :type => String
    field :grid_y, :type => String
    field :room_type, :type => String, :default => "IC"

    before_destroy :null_out_sources
    
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
    
    def null_out_sources
      sources = Exit.where(:dest_id => self.id)
      sources.each do |s|
        s.dest = nil
        s.save!
      end
    end
  end
end
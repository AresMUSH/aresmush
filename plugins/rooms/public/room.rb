module AresMUSH
  class Room
    attribute :room_grid_x
    attribute :room_grid_y
    attribute :room_type, :default => "IC"
    attribute :room_is_foyer, :type => DataType::Boolean
         
    index :room_type
        
    set :room_owners, "AresMUSH::Character"
    reference :area, "AresMUSH::Area"
    
    before_delete :clear_exits

    # DEPRECATED - use 'area' instead.
    attribute :room_area
    
    def clear_exits
      self.exits.each { |e| e.delete }
      self.exits_in.each { |e| e.delete }
    end
    
    def grid_x
      self.room_grid_x
    end
    
    def grid_y
      self.room_grid_y
    end
    
    def area_name
      self.area ? self.area.name : nil
    end
    
    def is_foyer?
      self.room_is_foyer
    end
    
    def owned_by?(char)
      self.room_owners.include?(char)
    end
    
    def name_and_area
      self.area ? "#{self.area.name}/#{self.name}" : self.name
    end
    
    def is_temp_room?
      self.scene && self.scene.temp_room
    end
    
    def grid_marker
      if (self.grid_x && self.grid_y)
        "(#{self.grid_x},#{self.grid_y})"
      else
        nil
      end
    end
    
    def self.find_by_name_and_area(search, enactor_room = nil)
      search = search || ""
      return [enactor_room] if search == "here" && enactor_room
      Room.all.select { |r| r.format_room_name_for_area_match(search).start_with?(search.upcase) }
    end
    
    def format_room_name_for_area_match(search)
      if (search =~ /\//)
        return "#{self.area_name}/#{self.name}".upcase
      else
        return self.name.upcase
      end
    end
    
    def clients
      list = []
      Global.client_monitor.clients.each do |c|
        char = c.char
        if (char && char.room == self)
          list << c
        end
      end
      list
    end
    
    def emit(message)
      return if self == Game.master.quiet_room
      self.clients.each { |c| c.emit message }
    end

    def emit_ooc(message)
      return if self == Game.master.quiet_room
      self.clients.each { |c| c.emit_ooc message }
    end
    
    def emit_failure(message)
      return if self == Game.master.quiet_room
      self.clients.each { |c| c.emit_failure message }
    end
    
    def emit_success(message)
      return if self == Game.master.quiet_room
      self.clients.each { |c| c.emit_success message }
    end
    
    def emit_raw(message)
      return if self == Game.master.quiet_room
      self.clients.each { |c| c.emit_raw message }
    end
  end
end
module AresMUSH
  class Room
    include BaseModel

    has_many :exits, :class_name => 'AresMUSH::Exit', :foreign_key => :source_id
    has_many :characters, :class_name => 'AresMUSH::Character'
    
    def self.find_all_by_name_or_id(name_or_id)
      where( { :$or => [ { :name_upcase => name_or_id.upcase }, { :id => name_or_id } ] } ).all
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
      exits.any? { |e| e.name_upcase == name.upcase }
    end
    
  end
end

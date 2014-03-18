module AresMUSH
  class Room    
    include MongoMapper::Document
    
    key :name
    has_many :exits, :class_name => 'AresMUSH::Exit', :foreign_key => :source_id
    has_many :characters, :class_name => 'AresMUSH::Character'
    
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
  end
end

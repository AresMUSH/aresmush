module AresMUSH
  class Room    
    include MongoMapper::Document
    
    key :name
    key :name_upcase, String
    
    has_many :exits, :class_name => 'AresMUSH::Exit', :foreign_key => :source_id
    has_many :characters, :class_name => 'AresMUSH::Character'
    
    before_validation :save_upcase_name
    
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
    
    def save_upcase_name      
      @name_upcase = @name.nil? ? "" : @name.upcase
    end
  end
end

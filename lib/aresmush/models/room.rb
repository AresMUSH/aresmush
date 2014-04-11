module AresMUSH
  class Room
    include ObjectModel

    has_many :exits, :class_name => 'AresMUSH::Exit', :foreign_key => :source_id, :inverse_of => "source_id"
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
    
    def has_exit?(name)
      exits.any? { |e| e.name_upcase == name.upcase }
    end
    
    def serializable_hash(options={})
      hash = super(options)
      hash[:exits] = exits.map { |e| e.id }
      hash
    end  
  end
end

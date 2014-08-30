module AresMUSH
  class Room
    include ObjectModel

    has_many :exits, :class_name => 'AresMUSH::Exit', :foreign_key => :source_id, :inverse_of => "source_id", :dependent => :destroy
    has_many :characters, :class_name => 'AresMUSH::Character'

    register_default_indexes

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
      match = exits.select { |e| e.name_upcase == name.upcase }
      return match.first if !match.empty?
      return nil if name.upcase != "O"
      return nil if exits.empty?
      return exits.first
    end
    
    def out_exit
      get_exit("O")
    end
    
    def serializable_hash(options={})
      hash = super(options)
      hash[:exits] = exits.map { |e| e.id }
      hash
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

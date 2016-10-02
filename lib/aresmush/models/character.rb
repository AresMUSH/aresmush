module AresMUSH
  class Character < Ohm::Model
    include ObjectModel
    
    attribute :handle
    attribute :handle_id
    attribute :handle_upcase
    attribute :name
    attribute :name_upcase
    attribute :alias
    attribute :alias_upcase

    index :handle_upcase
    index :handle_id
    index :name_upcase
    index :alias_upcase
    
    reference :room, "AresMUSH::Room"
    
    set :roles, "AresMUSH::Role"
    
    # -----------------------------------
    # CLASS METHODS
    # -----------------------------------
    
    def self.find_any(name_or_id)
      return [] if !name_or_id
      result = Character[name_or_id]
      if (result)
        return [ result ]
      end
      
      find(name_upcase: name_or_id.upcase).union(alias_upcase: name_or_id.upcase).to_a
    end

    def self.find_one(name)
      find_any(name).first
    end
    
    def self.find_by_handle(name)
      return [] if name.nil?
      find(handle_upcase: name.upcase)
    end
    
    def self.found?(name)
      find_any(name).first
    end
  
    # Derived classes may implement name checking
    def self.check_name(name)
      nil
    end

    # -----------------------------------
    # INSTANCE METHODS
    # -----------------------------------
    
    def has_role?(name)
      role = Role.find(name: name).first
      self.roles.include?(role)
    end
        
    def is_master_admin?
      self == Game.master.master_admin
    end
    
    def save
      self.name_upcase = self.name ? self.name.upcase : nil
      self.alias_upcase = self.alias ? self.alias.upcase : nil
      self.handle_upcase = self.handle ? self.handle.upcase : nil
      super
    end
    
    def name_and_alias
      if (self.alias.blank?)
        name
      else
        "#{name} (#{self.alias})"
      end
    end
    
    def client
      Global.client_monitor.find_client(self)
    end
    
    def is_online?
      !self.client.nil?
    end
    
    def self.random_link_code
      (0...8).map { (65 + rand(26)).chr }.join
    end 
  end
end
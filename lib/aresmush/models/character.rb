module AresMUSH
  class Character < Ohm::Model
    include ObjectModel
    
    attribute :name
    attribute :name_upcase
    attribute :alias
    attribute :alias_upcase

    attribute :password_hash

    index :name_upcase
    index :alias_upcase
    
    reference :room, "AresMUSH::Room"
    reference :handle, "AresMUSH::Handle"
    
    set :roles, "AresMUSH::Role"
    
    before_save :save_upcase
    
    # -----------------------------------
    # CLASS METHODS
    # -----------------------------------
    
    def self.find_any_by_name(name_or_id)
      return [] if !name_or_id
      result = Character[name_or_id]
      if (result)
        return [ result ]
      end
      
      find(name_upcase: name_or_id.upcase).union(alias_upcase: name_or_id.upcase).to_a
    end

    def self.find_one_by_name(name)
      find_any_by_name(name).first
    end
    
    def self.found?(name)
      find_any_by_name(name).first
    end
  
    # Derived classes may implement name checking
    def self.check_name(name)
      nil
    end
    
    def self.find_by_handle(handle)
      Handle.find_any_by_name(handle.name).map { |h| h.character }
    end

    # -----------------------------------
    # INSTANCE METHODS
    # -----------------------------------
    
    def compare_password(entered_password)
      hash = BCrypt::Password.new(self.password_hash)
      hash == entered_password
    end
    
    def self.hash_password(password)
      BCrypt::Password.create(password)
    end
    
    def change_password(raw_password)
      self.password_hash = Character.hash_password(raw_password)
    end

    def self.check_password(password)
      return t('validation.password_too_short') if (password.length < 5)
      return t('validation.password_cant_have_equals') if (password.include?("="))
      return nil
    end
    
    def has_role?(name_or_role)
      return false if !self.roles
      
      if (name_or_role.class == Role)
        role = name_or_role
      else
        role = Role.find_one(name: name_or_role)
      end
      self.roles.include?(role)
    end
        
    def is_master_admin?
      self == Game.master.master_admin
    end
    
    def save_upcase
      self.name_upcase = self.name ? self.name.upcase : nil
      self.alias_upcase = self.alias ? self.alias.upcase : nil
    end
    
    def name_and_alias
      if (self.alias.blank?)
        name
      else
        "#{name} (#{self.alias})"
      end
    end
    
    def ooc_name
      if (self.handle)
        display_name = "#{self.name} (@#{self.handle.name})"
      else
        display_name = self.name
      end
      
      return display_name
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
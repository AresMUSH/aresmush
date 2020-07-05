module AresMUSH
  class Character < Ohm::Model
    include ObjectModel
    include FindByName
    
    attribute :name
    attribute :name_upcase
    attribute :alias
    attribute :alias_upcase
    attribute :fansi_on, :default => true
    attribute :color_mode, :default => "FANSI"
    attribute :screen_reader, :type => DataType::Boolean, :default => false
    attribute :ascii_mode_enabled, :type => DataType::Boolean, :default => false
    attribute :emoji_enabled, :type => DataType::Boolean, :default => true
    attribute :is_statue
    attribute :password_hash

    attribute :shortcuts, :type => DataType::Hash, :default => {}

    index :name_upcase
    index :alias_upcase
    
    reference :room, "AresMUSH::Room"
    reference :handle, "AresMUSH::Handle"
    reference :read_tracker, "AresMUSH::ReadTracker"
    
    set :roles, "AresMUSH::Role"
    
    before_save :save_upcase
    
    def is_statue?
      self.is_statue
    end
    
    # -----------------------------------
    # CLASS METHODS
    # -----------------------------------
    
    def self.find_any_by_name(name_or_id)
      return [] if !name_or_id
            
      if (name_or_id.start_with?("#"))
        return find_any_by_id(name_or_id.upcase)
      end
      
      found = find(name_upcase: name_or_id.upcase).union(alias_upcase: name_or_id.upcase).to_a
      return found if found.any?
      
      found = Character.all.select { |c| c.name_upcase.start_with?(name_or_id.upcase) }
      if (found.count == 1)
        return found
      else
        return []
      end
    end

    def self.find_one_by_name(name_or_id)      
      char = Character[name_or_id]
      return char if char
      
      find_any_by_name(name_or_id).first
    end
    
    def self.found?(name)
      !!find_one_by_name(name)
    end
  
    # The engine doesn't enforce name checking, but the a plugin can override this.
    # Just be sure not to have multiple plugins trying to redefine this same method.
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
      self.update(password_hash: Character.hash_password(raw_password))
    end

    def self.check_password(password)
      return t('validation.password_too_short') if (password.length < 5)
      return t('validation.password_cant_have_equals') if (password.include?("="))
      return nil
    end
    
    def self.dbref_prefix
      "C"
    end
    
    def has_role?(name_or_role)
      return false if !self.roles
      
      if (name_or_role.class == Role)
        role = name_or_role
      else
        role = Role.find_one_by_name(name_or_role)
      end
      return false if !role
      self.roles.include?(role)
    end
        
    def has_any_role?(names)
      if (!names.respond_to?(:any?))
        has_role?(names)
      else
        names.any? { |n| has_role?(n) }
      end
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
    
    def self.random_link_code
      (0...8).map { (33 + rand(94)).chr }.join
    end 
  end
end
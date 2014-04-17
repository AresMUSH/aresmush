module AresMUSH
  class Character
    include ObjectModel

    field :password_hash, :type => String
    field :roles, :type => Array, :default => []
        
    belongs_to :room, :class_name => 'AresMUSH::Room'

    register_default_indexes with_unique_name: true

    def change_password(raw_password)
      self.password_hash = Character.hash_password(raw_password)
    end

    def compare_password(entered_password)
      hash = BCrypt::Password.new(self.password_hash)
      hash == entered_password
    end
    
    def has_role?(name)
      self.roles.include?(name)
    end

    def has_any_role?(names)
      if (!names.respond_to?(:any?))
        has_role?(names)
      else
        names.any? { |n| self.roles.include?(n) }
      end
    end
    
    def self.check_password(password)
      return t('validation.password_too_short') if (password.length < 5)
      return t('validation.password_cant_have_equals') if (password.include?("="))
      return nil
    end
    
    def self.check_name(name)
      return t('validation.name_too_short') if (name.length < 3)
      return t('validation.name_must_be_capitalized') if (name[0].downcase == name[0])
      return t('validation.char_name_taken') if (Character.exists?(name))
      return nil
    end
    
    def self.exists?(name)
      existing_char = Character.find_by_name(name)
      return !existing_char.nil?
    end

    def self.hash_password(password)
      BCrypt::Password.create(password)
    end
    
    def serializable_hash(options={})
      hash = super(options)
      hash[:room] = self.room_id
      hash
    end  
  end
end
    
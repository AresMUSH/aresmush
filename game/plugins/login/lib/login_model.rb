module AresMUSH
  class Character
    field :email, :type => String
    field :terms_of_service_acknowledged, :type => Time
    field :watch, :type => String, :default => "all"
    field :password_hash, :type => String

    def compare_password(entered_password)
      hash = BCrypt::Password.new(self.password_hash)
      hash == entered_password
    end
    
    def self.hash_password(password)
      BCrypt::Password.create(password)
    end
    
  end  
end
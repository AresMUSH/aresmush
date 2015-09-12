module AresMUSH
  class Character
    field :idled_out, :type => String
    
    def self.active_chars
      Character.where(:idled_out.exists => false, :idled_out.ne => "")
    end
    
  end
end
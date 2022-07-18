module AresMUSH
  module CharDescTemplateFields

    def rank(char)
      char.rank
    end
    
    def actor(char)
      char.demographic('played by')
    end
    
    def profile_title(char)
      Profile.profile_title(char)
    end
    
  end
end
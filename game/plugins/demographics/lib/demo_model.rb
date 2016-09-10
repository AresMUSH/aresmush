module AresMUSH
  class Character
    field :height, :type => String
    field :physique, :type => String
    field :skin, :type => String
    field :fullname, :type => String
    field :gender, :type => String, :default => "Other"
    field :hair, :type => String
    field :eyes, :type => String
    field :birthdate, :type => Date
    field :callsign, :type => String
    
    def age
      Demographics.calculate_age(self.birthdate)
    end
    
    def demographic(name)
      case name
      when :height, :physique, :skin, :fullname, :gender, :hair, :eyes, :birthdate, :callsign
        return self.send(name)
      else
        return ""
      end
    end
  end
end
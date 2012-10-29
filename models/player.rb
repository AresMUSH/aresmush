module AresMUSH
  class Player< Sequel::Model
    many_to_one :dbref
  end
  
  class Dbref < Sequel::Model
  end
end
    
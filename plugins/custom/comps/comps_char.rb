<<<<<<< HEAD
module AresMUSH

  class Character < Ohm::Model
    collection :comps, "AresMUSH::Comps"
  end
end


class Comps < Ohm::Model
  include ObjectModel

  index :character
  reference :character, "AresMUSH::Character"
  attribute :comp_msg
  attribute :from

end
=======
module AresMUSH

  class Character < Ohm::Model
    collection :comps, "AresMUSH::Comps"
  end
end


class Comps < Ohm::Model
  include ObjectModel

  index :character
  reference :character, "AresMUSH::Character"
  attribute :comp_msg
  attribute :from

end
>>>>>>> 46fa0d75499f1ee394365d6780cfea5e50e1af96

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

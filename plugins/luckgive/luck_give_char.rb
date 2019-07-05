module AresMUSH

  class Character < Ohm::Model
    collection :luck_record, "AresMUSH::LuckRecord"
  end
end


class LuckRecord < Ohm::Model
  include ObjectModel

  index :character
  reference :character, "AresMUSH::Character"
  attribute :reason
  attribute :from

end

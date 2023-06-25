module AresMUSH
  class LuckRecord < Ohm::Model
    include ObjectModel

    index :character
    reference :character, "AresMUSH::Character"
    attribute :reason
    attribute :from
    attribute :to

  end
end
module AresMUSH

  class Character < Ohm::Model
    collection :comps, "AresMUSH::CompsRecord"
    attribute :comps_given, :type => DataType::Integer
  end
end


class CompsRecord < Ohm::Model
  include ObjectModel

  index :character
  reference :character, "AresMUSH::Character"
  attribute :comp_msg
  attribute :from
end

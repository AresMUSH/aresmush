module AresMUSH

  class Character < Ohm::Model
    collection :comps, "AresMUSH::Comps"
    attribute :comps_given, :type => DataType::Integer
  end
end


class Comps < Ohm::Model
  include ObjectModel

  reference :character, "AresMUSH::Character"
  attribute :comp_msg
  attribute :from
end

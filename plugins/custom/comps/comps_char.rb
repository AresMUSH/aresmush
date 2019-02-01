module AresMUSH

  class Character < Ohm::Model
    collection :comps, "AresMUSH::Comps"
  end
end


class Comps < Ohm::Model
  include ObjectModel

  index :character
  attribute :date, :type => Ohm::DataTypes::DataType::Time, :default => Time.now
  reference :character, "AresMUSH::Character"
  attribute :comp

end

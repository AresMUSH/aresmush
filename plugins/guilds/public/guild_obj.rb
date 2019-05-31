module AresMUSH
  class GuildObj < Ohm::Model
    include ObjectModel

    reference :character, "AresMUSH::Character"
    attribute :name
    attribute :ranking, :type => DataType::Integer, :default => 0
    attribute :title


    index :name
  end
end

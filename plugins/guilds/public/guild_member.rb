module AresMUSH
  class GuildMember < Ohm::Model
    include ObjectModel

    reference :character, "AresMUSH::Character"
    attribute :name
    attribute :rank, :type => DataType::Integer, :default => 0
    attribute :title


    index :name
  end
end

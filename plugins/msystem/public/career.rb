module AresMUSH
  class MsystemSkill < Ohm::Model
    include ObjectModel

    reference :character, "AresMUSH::Character"
    attribute :name
    attribute :type
    attribute :points, :type => DataType::Integer, :default => 0

    index :name
  end
end
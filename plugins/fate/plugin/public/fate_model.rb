module AresMUSH
  class Character < Ohm::Model
    attribute :fate_aspects, :type => DataType::Array, :default => []
    attribute :fate_stunts, :type => DataType::Hash, :default => {}
    attribute :fate_skills, :type => DataType::Hash, :default => {}
    attribute :fate_points, :type => DataType::Integer
    attribute :fate_refresh, :type => DataType::Integer
  end
end
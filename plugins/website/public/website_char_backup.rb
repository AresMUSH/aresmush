module AresMUSH
  class WikiCharBackup < Ohm::Model
    reference :char, "AresMUSH::Character"
    
    attribute :created_at, :type => Ohm::DataTypes::DataType::Time
    attribute :path
  end
end
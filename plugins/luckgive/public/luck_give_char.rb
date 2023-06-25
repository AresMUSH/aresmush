module AresMUSH
  class Character < Ohm::Model
    collection :luck_record, "AresMUSH::LuckRecord"
  end
end
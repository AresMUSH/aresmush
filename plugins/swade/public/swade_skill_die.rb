module AresMUSH
  class Swade < Ohm::Model
    include ObjectModel
    include LearnableAbility
    
    reference :character, "AresMUSH::Character"
    attribute :name
    attribute :rating, :type => DataType::Integer, :default => 0
    attribute :specialties, :type => DataType::Array, :default => []
    index :name
    
    def die_rating
      case rating
      when 0
        return ""
      when 1
        return "<i class='fad fa-dice-d4'></i>"
      when 2
        return "<i class='fad fa-dice-d6'></i>"
      when 3
        return "<i class='fad fa-dice-d8'></i>"
      when 4
        return "<i class='fad fa-dice-d10'></i>"
      when 5
        return "<i class='fad fa-dice-d12'></i>" 
      end
    end
    
  end
end
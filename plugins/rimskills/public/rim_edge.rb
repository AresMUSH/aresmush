module AresMUSH
  class RiMEdge < Ohm::Model
    include ObjectModel
#    include LearnableAbility

    reference :character, "AresMUSH::Character"
    attribute :name
    attribute :rating, :type => DataType::Integer, :default => 0
    attribute :context

    index :name
    index :context

    def print_rating
      case rating
      when 0
        return "0"
      when 1
        return "%x462%xn"
      when 2
        return "%xy2%xn"
      when 3
        return "%x1963%xn"
      when 4
        return "%x2004%xn"
      end
    end
  end
end

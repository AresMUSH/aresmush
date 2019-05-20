module AresMUSH
  class FS3Spell < Ohm::Model
    include ObjectModel
    include LearnableAbility

    reference :character, "AresMUSH::Character"
    attribute :name
    attribute :rating, :type => DataType::Integer, :default => 0
    attribute :is_learned, :type => DataType::Boolean, :default => false

    index :rating
    index :name

    def print_rating
      case rating
      when 0
        return "0"
      when 1
        return "%xg1%xn"
      when 2
        return "%xg2%xn"
      when 3
        return "%xy3%xn"
      when 4
        return "%xy4%xn"
      when 5
        return "%xr5%xn"
      when 6
        return "%xr6%xn"
      when 7
        return "%xb7%xn"
      when 8
        return "%xb8%xn"
      end
    end
  end
end

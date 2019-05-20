module AresMUSH
  class RiMAbility < Ohm::Model
    include ObjectModel
#    include LearnableAbility

    reference :character, "AresMUSH::Character"
    attribute :name
    attribute :rating, :type => DataType::Integer, :default => 0
    attribute :learned, :type => DataType::Boolean, :default => false
    attribute :category

    index :category
    index :name

    def print_rating
      case rating
      when 0
        return "0"
      when 1
        return "%x1141%xn"
      when 2
        return "%x462%xn"
      when 3
        return "%xy3%xn"
      when 4
        return "%x1784%xn"
      when 5
        return "%x1965%xn"
      when 6
        return "%x2006%xn"
      end
    end
  end
end

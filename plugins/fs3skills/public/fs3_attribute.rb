module AresMUSH
  class FS3Attribute < Ohm::Model
    include ObjectModel
    include LearnableAbility

    reference :character, "AresMUSH::Character"
    attribute :name
    attribute :rating, :type => DataType::Integer, :default => 0

    index :name

    def print_rating
      case rating
      when 0
        return "0"
      when 1
        return "%xh%xg1%xn"
      when 2
        return "%xh%xg2%xn"
      when 3
        return "%xh%xy3%xn"
      when 4
        return "%xh%xr4%xn"
      when 5
        return "%xh%xb5%xn"
      end
    end

    def rating_name
      case rating
      when 0
        return ""
      when 1
        return t('fs3skills.poor_rating')
      when 2
        return t('fs3skills.average_rating')
      when 3
        return t('fs3skills.good_rating')
      when 4
        return t('fs3skills.exceptional_rating')
      end
    end
  end
end

module AresMUSH
  class FS3ActionSkill < Ohm::Model
    include ObjectModel
    include LearnableAbility

    reference :character, "AresMUSH::Character"
    attribute :name
    attribute :rating, :type => DataType::Integer, :default => 0
    attribute :specialties, :type => DataType::Array, :default => []
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

    def rating_name
      case rating
      when 0
        return t('fs3skills.unskilled_rating')
      when 1
        return t('fs3skills.everyman_rating')
      when 2
        return t('fs3skills.fair_rating')
      when 3
        return t('fs3skills.competent_rating')
      when 4
        return t('fs3skills.good_rating')
      when 5
        return t('fs3skills.great_rating')
      when 6
        return t('fs3skills.exceptional_rating')
      when 7
        return t('fs3skills.amazing_rating')
      when 8
        return t('fs3skills.legendary_rating')
      end
    end
  end
end

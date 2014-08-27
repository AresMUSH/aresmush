module AresMUSH
  module FS3Skills
    # Expects titleized ability name
    def self.roll_ability(char, ability, modifier)
      
    end
    
    # Expects titleized ability name
    def self.ability_rating(char, ability)
    end
    
    def self.print_skill_rating(rating)
      num_dots = [rating, 3].min
      dots = print_dots(num_dots, "%xg")

      if (rating > 3)
        num_dots = [rating - 3, 3].min
        dots = dots + print_dots(num_dots, "%xy")
      end
      
      if (rating > 6)
        num_dots = [rating - 6, 3].min
        dots = dots + print_dots(num_dots, "%xr")
      end
      
      if (rating > 9)
        num_dots = [rating - 9, 3].min
        dots = dots + print_dots(num_dots, "%xb")
      end
      dots
    end
    
    def self.print_attribute_rating(rating)
      case rating
      when 0
        ""
      when 1
        "%xg@%xn"
      when 2
        "%xg@%xy@%xn"
      when 3
        "%xg@%xy@%xr@%xn"
      when 4
        "%xg@%xy@%xr@%xb@%xn"
      end
    end
    
    def self.print_dots(number, color)
      dots = number.times.collect { "@" }.join
      "#{color}#{dots}%xn"
    end
  end
end
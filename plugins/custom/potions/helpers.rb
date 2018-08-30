module AresMUSH
  module Custom

    def self.find_potion_creating(char, potion)
      char.potions_creating.select { |a| a.name == potion }.first
    end
    
    def self.update_potion_hours(char)
        potions_creating = char.potions_creating
        potions_has = char.potions_has
        potions_creating.each do |p|
          hours_to_creation = p.hours_to_creation.to_i - 1
          if hours_to_creation < 1
            PotionsHas.create(name: p.name, character: char)
            p.delete            
          else
            p.update(hours_to_creation: hours_to_creation)
          end
        end
    end
     
    def self.potions_creating
      @char.potions_creating.to_a
    end
    
    def self.find_potion_has (char, potion)
      char.potions_has.select { |a| a.name == potion }.first
    end
    

    
  end
end
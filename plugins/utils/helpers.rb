module AresMUSH
  module Utils
    def self.can_access_notes?(actor)
      actor.has_permission?("manage_notes")
    end
    
    def self.roll_dice(name, num, sides)
      return nil if num > 10 || num <= 0 || sides <= 0 || sides >= 100
      
      results = num.times.collect { |d| rand(sides) + 1 }
      return t('dice.rolls_dice', :name => name,
        :dice => "#{num}d#{sides}",
        :results => results)
    end
  end
end
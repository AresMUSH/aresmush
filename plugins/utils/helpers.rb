module AresMUSH
  module Utils
    def self.can_manage_notes?(actor)
      actor && actor.has_permission?("manage_notes")
    end
    
    def self.can_access_notes?(char, viewer, section)
      return false if !viewer
      can_manage_notes = Utils.can_manage_notes?(viewer)
      case section
      when 'player'
        return char == viewer
      when 'shared'
        return true if char == viewer
        return can_manage_notes
      else
        return can_manage_notes
      end
    end
    
    def self.note_sections
      [ 'player', 'admin', 'shared' ]
    end
    
    def self.roll_dice(name, num, sides)
      return nil if num > 10 || num <= 0 || sides <= 0 || sides > 100
      
      results = num.times.collect { |d| rand(sides) + 1 }
      return t('dice.rolls_dice', :name => name,
        :dice => "#{num}d#{sides}",
        :results => results)
    end
  end
end
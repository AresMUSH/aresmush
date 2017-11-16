module AresMUSH
  
  puts "======================================================================="
  puts "Resetting scene deletion warnings."
  puts "======================================================================="
    
  class Combatant
    attribute :armor
  end
  
  Combatant.all.each do |c|
    c.update(armor_name: c.armor)
    c.update(armor: nil)
    c.update(armor_specials: [])
  end
  
  puts "Upgrade complete!"
end
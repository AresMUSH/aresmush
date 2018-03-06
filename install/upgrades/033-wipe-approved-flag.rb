module AresMUSH
  
  puts "======================================================================="
  puts "Remove approved flag."
  puts "======================================================================="
  
  class Character
    attribute :is_approved
  end
  
  Character.all.each { |j| j.update(is_approved: nil) }    
  
  puts "Upgrade complete!"
end
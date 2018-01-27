module AresMUSH
  
  puts "======================================================================="
  puts "An example that creates a new forum category."
  puts "======================================================================="
  
  BbsBoard.create(name: "Example Upgrade Test", order: 99)
  
  puts "Upgrade complete!"
end
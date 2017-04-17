module AresMUSH
  
  puts "======================================================================="
  puts "Adding messages to channel history."
  puts "======================================================================="
  

  Channel.all.each do |c|
    c.update(messages: [])
    c.update(recall_enabled: true)
  end
  
  
  puts "Upgrade complete!"
end
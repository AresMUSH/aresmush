module AresMUSH
  
  puts "======================================================================="
  puts "Add timestamps to channel history. "
  puts "======================================================================="
  
 
  Channel.all.each do |c|
    messages = c.messages
    new_messages = c.messages.map { |m| { message: m, timestamp: DateTime.now }}
    c.update(messages: new_messages)
  end
  puts "Upgrade complete!"
end
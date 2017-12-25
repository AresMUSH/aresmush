module AresMUSH
  
  puts "======================================================================="
  puts "Resetting nil rooms."
  puts "======================================================================="
    
  Character.all.each do |c|
    if (!c.room)
      c.update(room: Game.master.ic_start_room)
    end
  end
  
  puts "Upgrade complete!"
end
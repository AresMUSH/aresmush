module AresMUSH
  
  
  puts "======================================================================="
  puts "Adding repose nudge and notes."
  puts "======================================================================="

  Character.all.each do |c|
    c.update(pose_nudge: true)
    c.update(notes: {})
  end
  
  puts "Upgrade complete!"
end




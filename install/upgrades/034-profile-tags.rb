module AresMUSH
  
  puts "======================================================================="
  puts "Make sure profile tags aren't null."
  puts "======================================================================="
  
 
  Character.all.each do |c| 
    if (!c.profile_tags)
      c.update(profile_tags: [])
    end
  end
  
  puts "Upgrade complete!"
end
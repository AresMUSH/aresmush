module AresMUSH
  
  puts "======================================================================="
  puts "Add XP and shortcuts."
  puts "======================================================================="
  
  Character.all.each { |c| c.update(shortcuts: {} )}
  
  FS3Attribute.all.each do |a|
    a.update(last_learned: a.character.created_at)
    a.update(xp: 0)
  end
  
  FS3ActionSkill.all.each do |a|
    a.update(last_learned: a.character.created_at)
    a.update(xp: 0)
  end
  
  FS3BackgroundSkill.all.each do |a|
    a.update(last_learned: a.character.created_at)
    a.update(xp: 0)
  end
  
  FS3Language.all.each do |a|
    a.update(last_learned: a.character.created_at)
    a.update(xp: 0)
  end
  
  puts "Upgrade complete!"
end
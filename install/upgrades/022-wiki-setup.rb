module AresMUSH
  load "/home/ares/aresmush/game/plugins/website/filename_sanitizer.rb"
  
  puts "======================================================================="
  puts "Creating wiki starter pages."
  puts "======================================================================="
    
  home = WikiPage.create(name: "home")
  WikiPageVersion.create(wiki_page: home, text: "Wiki home page", character: Game.master.system_character)
  
  Scene.all.each do |s|
    s.update(tags: [])
  end
  
  Character.all.each do |c|
    c.update(profile_tags: [])
  end
  
  puts "Upgrade complete!"
end
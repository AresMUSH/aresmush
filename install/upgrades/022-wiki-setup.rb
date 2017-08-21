module AresMUSH
  
  puts "======================================================================="
  puts "Creating wiki starter pages."
  puts "======================================================================="
  
  WikiPageVersion.all.each { |p| p.delete }
  WikiPage.all.each { |p| p.delete }
  
  home = WikiPage.create(name: "home")
  WikiPageVersion.create(wiki_page: home, text: "Wiki home page")
  
  puts "Upgrade complete!"
end
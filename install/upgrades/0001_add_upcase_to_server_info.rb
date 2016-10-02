module AresMUSH
  bootstrapper = AresMUSH::Bootstrapper.new
  
  puts "======================================================================="
  puts "Update some new fields in server info"
  puts "======================================================================="
  
  ServerInfo.all.each do |s|
    if (s.category.nil?)
      s.category = "Social"
    end
    s.game_open = true
    s.name_upcase = s.name.upcase
    s.category_upcase = s.category.upcase
    s.save
  end
  
  puts "Upgrade complete!"
end
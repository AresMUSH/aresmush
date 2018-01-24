module AresMUSH
  
  puts "======================================================================="
  puts "Remove cached html on wiki pages."
  puts "======================================================================="
  
  class WikiPage
    attribute :html
  end
  
  WikiPage.all.each do |p|
    p.update(html: nil)
  end
  
  puts "Upgrade complete!"
end
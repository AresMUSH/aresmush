module AresMUSH
  
  puts "======================================================================="
  puts "Resetting AresCentral API key."
  puts "======================================================================="

  new_key = ENV['ares_rake_param']
    
    game = Game.master
    game.update(api_key, new_key)
  
    puts "Script complete!"
  end
end
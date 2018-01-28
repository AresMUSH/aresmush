module AresMUSH
  
  puts "======================================================================="
  puts "Changing Arescentral api key to the desired value.  The API key must come from the AresCentral admin."
  puts "======================================================================="

  new_key = ENV['ares_rake_param']
  if (!new_key)
    raise "Missing key!"
  else
    
    game = Game.master
    game.update(api_key, new_key)
  
    puts "Upgrade complete!"
  end
end
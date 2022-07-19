module AresMUSH
  
  puts "======================================================================="
  puts "Enabling HTTPS."
  puts "======================================================================="

  config = DatabaseMigrator.read_config_file("server.yml")
  config['server']['use_https'] = true
  DatabaseMigrator.write_config_file("server.yml", config)     
  
  puts "Script complete!"
end
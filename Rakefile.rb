$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w[lib]))

require 'aresmush'
require 'erubis'
require 'rspec'
require 'rspec/core/rake_task'
require 'tempfile'
require 'mongoid'

task :start do
  bootstrapper = AresMUSH::Bootstrapper.new
  bootstrapper.command_line.start
end
  
task :install do

end
  
task :configure do
    
  puts "\nLet's set up your database.  Please enter the requested information."

  print "Database host > "
  db_host = STDIN.gets.chomp

  print "\nDatabase port > "
  db_port = STDIN.gets.chomp

  print "\nDatabase name > "
  db_name = STDIN.gets.chomp

  print "\nDatabase user > "
  db_user = STDIN.gets.chomp

  print "\nDatabase password > "
  db_password = STDIN.gets.chomp
  
  template_data =
  {
    "db_host" => db_host,
    "db_port" => db_port,
    "db_name" => db_name,
    "db_user" => db_user,
    "db_password" => db_password
  }
  
  template = Erubis::Eruby.new(File.read(File.join('install', 'database.yml.erb')))
  File.open(File.join(AresMUSH.game_path, 'config', 'database.yml'), 'w') do |f|
    f.write(template.evaluate(template_data))
  end
  
  puts "\nYour database is configured.  Now we'll set up your server information."
  
  print "\nServer hostname > "
  server_host = STDIN.gets.chomp

  print "\nServer port > "
  server_port = STDIN.gets.chomp

  print "\nMUSH Name > "
  mush_name = STDIN.gets.chomp

  print "\nMUSH Description > "
  game_desc = STDIN.gets.chomp

  print "\nWebsite > "
  website = STDIN.gets.chomp
  
  print "\nMUSH Category > "
  print "\nPick one:"
  print "\n[1] Social"
  print "\n[2] Historical"
  print "\n[3] Sci-Fi"
  print "\n[4] Fantasy"
  print "\n[5] Modern"
  print "\n[6] Supernatural"
  print "\n[7] Other"
  print "\n Select a Category > "
  input = STDIN.gets.chomp

  case input
  when "1"
    category = "Social"
  when "2"
    category = "Historical"
  when "3"
    category = "Sci-Fi"
  when "4" 
    category = "Fantasy"
  when "5"
    category = "Modern"
  when "6"
    category = "Supernatural"
  else
    category = "Other"
  end
  
  template_data = 
  {
    "host_name" => server_host,
    "host_port" => server_port,
    "mush_name" => mush_name,
    "category" => category,
    "game_desc" => game_desc,
    "website" => website
  }
  
  template = Erubis::Eruby.new(File.read(File.join('install', 'server.yml.erb')))
  File.open(File.join(AresMUSH.game_path, 'config', 'server.yml'), 'w') do |f|
    f.write(template.evaluate(template_data))
  end
  
  puts "\nYour game has been configured!  You can edit these and other game options through the files in game/config."
end

task :init do
    
  bootstrapper = AresMUSH::Bootstrapper.new
  
  Mongoid.purge!
  
  AresMUSH::ObjectModel.models.each do |m|
    puts "Clearing out #{m}"
    #m.delete_all
    #m.remove_indexes
    m.create_indexes
  end

  game = AresMUSH::Game.create

  puts "Creating start rooms."
  
  welcome_room = AresMUSH::Room.create(:name => "Welcome Room", :room_type => "OOC")
  ic_start_room = AresMUSH::Room.create(:name => "IC Start", :room_type => "IC")
  ooc_room = AresMUSH::Room.create(:name => "OOC Center", :room_type => "OOC")
  
  game.welcome_room = welcome_room
  game.ic_start_room = ic_start_room
  game.ooc_room = ooc_room
  game.save!
  
  puts "Creating OOC chars."
      
  headwiz = AresMUSH::Character.new(name: "Headwiz")
  headwiz.change_password("change_me!")
  headwiz.roles << "admin"
  headwiz.save!
  
  builder = AresMUSH::Character.new(name: "Builder")
  builder.change_password("change_me!")
  builder.roles << "builder"
  builder.save!
  
  systemchar = AresMUSH::Character.new(name: "System")
  systemchar.change_password("change_me!")
  systemchar.roles << "admin"
  systemchar.save!

  4.times do |n|
    guest = AresMUSH::Character.new(name: "Guest-#{n+1}")
    guest.change_password("guest")
    guest.roles << "guest"
    guest.save!
  end

  game.master_admin = headwiz
  game.system_character = systemchar
  game.save!
  
  puts "Creating server info."
  
  AresMUSH::ServerInfo.create(
  game_id: AresMUSH::ServerInfo.arescentral_game_id,
  name: "AresCentral", 
  description: "Central hub for all things AresMUSH-related.", 
  host: "mush.aresmush.com",
  port: 7206)
    
  puts "Creating channels and BBS."
  
  AresMUSH::BbsBoard.create(name: "Announcements", order: 1)
  AresMUSH::BbsBoard.create(name: "Admin", order: 2, read_roles: [ "admin"], write_roles: [ "admin" ])
  
  AresMUSH::Channel.create(name: "Chat", announce: false, description: "Public chit-chat.", color: "%xy")
  AresMUSH::Channel.create(name: "Questions", description: "Questions and answers.", color: "%xg")
  AresMUSH::Channel.create(name: "Admin", description: "Admin business.", roles: ["admin"], color: "%xr")
  
  
  puts "Install complete."
end

task :upgrade do
  bootstrapper = AresMUSH::Bootstrapper.new
end

desc "Run all specs."
begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec, :tag) do |t, task_args|
    tag = task_args[:tag]
    if (tag)
      t.rspec_opts = "--example #{tag}"
    end
  end
rescue LoadError
  # no rspec available
end

desc "Run all specs except the db ones."
begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new('spec:unit', :tag) do |t, task_args|
    t.rspec_opts = "--tag ~dbtest"
  end
rescue LoadError
  # no rspec available
end

task :default => 'spec:unit'


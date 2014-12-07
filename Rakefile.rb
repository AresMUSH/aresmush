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
  headwiz.change_password("wizb00ts")
  headwiz.roles << "admin"
  headwiz.save!
  
  builder = AresMUSH::Character.new(name: "Builder")
  builder.change_password("buildme")
  builder.roles << "builder"
  builder.save!
  
  systemchar = AresMUSH::Character.new(name: "System")
  systemchar.change_password("wizb00ts")
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


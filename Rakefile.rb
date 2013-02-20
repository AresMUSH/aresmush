$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w[lib]))
require 'rubygems'
require 'rake'
require 'rspec/core/rake_task'
require 'aresmush'
task :dbstart do
  sh "mongod --config mongo.conf"
end

task :start do
  bootstrapper = AresMUSH::Bootstrapper.new
  bootstrapper.command_line.start
end

task :install do
  bootstrapper = AresMUSH::Bootstrapper.new
  db[:players].drop
  db[:exits].drop
  db[:rooms].drop
  db[:game].drop
  AresMUSH::Room.drop_all
  AresMUSH::Exit.drop_all
  AresMUSH::Player.drop_all
  AresMUSH::Game.drop_all
  
  welcome = AresMUSH::Room.create("name" => "Welcome Room")
  ic = AresMUSH::Room.create("name" => "IC Start")
  idle = AresMUSH::Room.create("name" => "Idle Lounge")
  
  AresMUSH::Game.create
  game = AresMUSH::Game.get
  game['rooms'] = 
  {
    'welcome_id' => welcome[:_id],
    'ic start_id' => ic[:_id],
    'idle_id' => idle[:_id]
  }
  AresMUSH::Game.update(game)
  
  headwiz = AresMUSH::Player.create(
  {
   "name" => "Headwiz", 
   "location" => welcome[:_id],
   "password" => AresMUSH::Player.hash_password("wizb00ts"),
  })
  
  puts "Install complete."
end

task :default => :start
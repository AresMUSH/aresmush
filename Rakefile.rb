$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w[lib]))

require 'aresmush'

task :start do
  bootstrapper = AresMUSH::Bootstrapper.new
  bootstrapper.command_line.start
end

task :install do
  bootstrapper = AresMUSH::Bootstrapper.new
  AresMUSH.db[:chars].drop
  AresMUSH.db[:exits].drop
  AresMUSH.db[:rooms].drop
  AresMUSH.db[:game].drop
  AresMUSH::Room.drop_all
  AresMUSH::Exit.drop_all
  AresMUSH::Character.drop_all
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
  
  headwiz = AresMUSH::Character.create(
  {
   "name" => "Headwiz", 
   "location" => welcome[:_id],
   "password" => AresMUSH::Character.hash_password("wizb00ts"),
  })
  
  puts "Install complete."
end

task :default => :start
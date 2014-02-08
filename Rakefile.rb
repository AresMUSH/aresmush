$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w[lib]))

require 'aresmush'

task :start do
  bootstrapper = AresMUSH::Bootstrapper.new
  bootstrapper.command_line.start
end

task :install do
 
  # TODO - Plugins need some way to install themselves?  What about upgrade?
  # TODO - Break up wipe and install
  
  bootstrapper = AresMUSH::Bootstrapper.new
  AresMUSH::Global.db[:chars].drop
  AresMUSH::Global.db[:exits].drop
  AresMUSH::Global.db[:rooms].drop
  AresMUSH::Room.drop_all
  AresMUSH::Exit.drop_all
  AresMUSH::Character.drop_all

  AresMUSH::Game.delete_all  
  game = AresMUSH::Game.new

  welcome = AresMUSH::Room.create("name" => "Welcome Room")
  ic = AresMUSH::Room.create("name" => "IC Start")
  idle = AresMUSH::Room.create("name" => "Idle Lounge")
    
  game.welcome_room_id = welcome[:_id]
  game.ic_start_room_id = ic[:_id]
  game.idle_room_id = idle[:_id]
  game.save!

  
  headwiz = AresMUSH::Character.create(
  {
   "name" => "Headwiz", 
   "location" => welcome[:_id],
   "password" => AresMUSH::Character.hash_password("wizb00ts"),
  })
  
  puts "Install complete."
end

task :default => :start
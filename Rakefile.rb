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
  AresMUSH::Global.db[:exits].drop
  AresMUSH::Global.db[:rooms].drop
  AresMUSH::Room.drop_all
  AresMUSH::Exit.drop_all

  AresMUSH::Character.delete_all
  AresMUSH::Game.delete_all  
  
  game = AresMUSH::Game.create
  game.save!

  headwiz = AresMUSH::Character.new()
  headwiz.change_password("wizb00ts")
  headwiz.name = "Headwiz"
  headwiz.save!

  puts "Install complete."
end

task :default => :start
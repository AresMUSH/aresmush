$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w[lib]))

require 'aresmush'

task :start do
  bootstrapper = AresMUSH::Bootstrapper.new
  bootstrapper.command_line.start
end

task :install do
 
  # TODO - What about upgrade?  Break up wipe and install, make plugins smarter
  
  bootstrapper = AresMUSH::Bootstrapper.new

  AresMUSH::Character.delete_all
  AresMUSH::Game.delete_all  
  AresMUSH::Room.delete_all
  AresMUSH::Exit.delete_all
  
  game = AresMUSH::Game.create
  
  headwiz = AresMUSH::Character.create
  headwiz.change_password("wizb00ts")
  headwiz.name = "Headwiz"
  headwiz.save!

  puts "Install complete."
end

task :default => :start
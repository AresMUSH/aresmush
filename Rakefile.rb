$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w[lib]))

require 'aresmush'
require 'erubis'
require 'rspec'
require 'rspec/core/rake_task'
require 'tempfile'
#require 'mongoid'
require_relative 'install/init_db.rb'
require_relative 'install/configure_game.rb'

task :startares do
  bootstrapper = AresMUSH::Bootstrapper.new
  bootstrapper.start
end
  
task :configure do
  AresMUSH::Install.configure_game
end

task :testinit do
  load "game/plugins/bbs/bbs.rb"
  load "game/plugins/describe/describe.rb"
  load "game/plugins/channels/channels.rb"
  load "game/plugins/pose/pose.rb"
  load "game/plugins/rooms/rooms.rb"
  load "game/plugins/login/login.rb"

  bootstrapper = AresMUSH::Bootstrapper.new
  AresMUSH::Character.all.each do |c|
    puts c.inspect
  end
  
  c = AresMUSH::Character.find_one("Headwiz")
  puts c.inspect
  
  
  puts AresMUSH::Game[1].inspect
end

task :init do    
  bootstrapper = AresMUSH::Bootstrapper.new
  
  load "game/plugins/bbs/bbs.rb"
  load "game/plugins/pose/pose.rb"
  load "game/plugins/describe/describe.rb"
  load "game/plugins/channels/channels.rb"
  load "game/plugins/rooms/rooms.rb"
  load "game/plugins/login/login.rb"
  AresMUSH::Install.init_db
end

task :upgrade, [:scriptname] do |t, args|
  scriptname = args[:scriptname]
  require_relative "install/upgrades/#{scriptname}.rb"
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


# Generate documentation
#require 'rdoc/task'

#RDoc::Task.new do |rdoc|
#  rdoc.rdoc_dir = 'rdoc'
#  rdoc.main = "README.doc"
  
#  plugin_files = AresMUSH::PluginManager.plugin_files
#  templates = plugin_files.select { |f| f =~ /template/ }
   
#  rdoc.rdoc_files = templates
#  rdoc.rdoc_files.include("game/plugins/**/*.rb")
#  rdoc.rdoc_files.exclude("^((?!Template).)*$")
#end

task :default => 'spec:unit'


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

task :default => :start
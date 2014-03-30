$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w[lib]))

require 'aresmush'
require 'erubis'
require 'rspec/core/rake_task'
require 'tempfile'


task :start do
  bootstrapper = AresMUSH::Bootstrapper.new
  bootstrapper.command_line.start
end

namespace :db do
  game_db_path      = File.join(AresMUSH.game_path, 'db')
  mongo_config_file = File.join(game_db_path, 'mongo.conf')
  mongo_pid_file    = File.join(game_db_path, 'mongodb.pid')
  AresMUSH::ConfigReader.new.read
  config          = AresMUSH::ConfigReader.config
  db_auth_enabled = ENV['ARES_DB_AUTH_DISABLED'] || 'true'
  template_data   = {
      db_host:           config['database']['host'],
      db_path:           game_db_path,
      db_port:           config['database']['port'],
      db_name:           config['database']['database'],
      db_username:       config['database']['username'],
      db_password:       config['database']['password'],
      db_admin_password: config['database']['admin_password'],
      db_auth_enabled:   db_auth_enabled
  }

  task :start do
    template = Erubis::Eruby.new(File.read(File.join(AresMUSH.game_path, 'db', 'mongo.conf.erb')))
    File.open(mongo_config_file, 'w') { |f| f.write(template.evaluate(template_data)) }
    sh "mongod -f #{mongo_config_file}"
  end

  task :stop do
    pid = File.read(mongo_pid_file)
    sh "kill #{pid}"
    sh "rm #{mongo_pid_file}"
  end

  task :bootstrap do
    raise "Mongo is running" if File.exists? mongo_pid_file
    template = Erubis::Eruby.new(File.read(File.join(AresMUSH.game_path, 'db', 'bootstrap.js.erb')))
    template_data[:db_auth_enabled] = false
    Rake::Task['db:start'].execute
    Kernel.sleep 5.seconds
    script = Tempfile.new(['aresmush_bootstrap','.js'])
    data = template.evaluate(template_data)
    puts data
    File.open(script,'w+') { |f| f.write(data)}
    cmd =<<-eos
      mongo #{template_data[:db_host]}:#{template_data[:db_port]} #{script.path}
    eos
    puts cmd
    sh cmd
    Rake::Task['db:stop'].execute
  end
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

namespace :unit do
  RSpec::Core::RakeTask.new do |t|
    t.pattern = FileList["specs/**/*_spec?.rb"]
  end
end
namespace :plugin do
  RSpec::Core::RakeTask.new do |t|
    t.pattern = FileList["game/*/spec?/**/*_spec?.rb"]
  end
end

task :default => :start


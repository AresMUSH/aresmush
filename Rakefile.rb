$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w[lib]))

require 'aresmush'
require 'erubis'
require 'rspec/core/rake_task'
require 'tempfile'
require 'mongoid'

task :start do
  bootstrapper = AresMUSH::Bootstrapper.new
  bootstrapper.command_line.start
end

namespace :db do
  namespace :local do
    game_db_path = File.join(AresMUSH.game_path, 'db')
    mongo_config_file = File.join(game_db_path, 'mongo.conf')
    mongo_pid_file = File.join(game_db_path, 'mongodb.pid')
    config_reader = AresMUSH::ConfigReader.new
    config_reader.read
    config = config_reader.config
    db_auth_enabled = ENV['ARES_DB_AUTH_DISABLED'] || 'true'

    template_data = {
      db_path: game_db_path,
      db_host: config['database']['production']['sessions']['default']['hosts'].first.split(/:/)[0],
      db_port: config['database']['production']['sessions']['default']['hosts'].first.split(/:/)[1],
      db_name: config['database']['production']['sessions']['default']['database'],
      db_username: config['database']['production']['sessions']['default']['username'],
      db_password: config['database']['production']['sessions']['default']['password'],
      test_db_host: config['database']['test']['sessions']['default']['hosts'].first.split(/:/)[0],
      test_db_port: config['database']['test']['sessions']['default']['hosts'].first.split(/:/)[1],
      test_db_name: config['database']['test']['sessions']['default']['database'],
      test_db_username: config['database']['test']['sessions']['default']['username'],
      test_db_password: config['database']['test']['sessions']['default']['password'],
      db_auth_enabled: db_auth_enabled
    }

    task :start do
      raise "Host not local!" unless (template_data[:db_host] == 'localhost' || template_data[:db_host] == '127.0
.0.1')
      template = Erubis::Eruby.new(File.read(File.join(AresMUSH.game_path, 'db', 'mongo.conf.erb')))
      File.open(mongo_config_file, 'w') { |f| f.write(template.evaluate(template_data)) }
      sh "mongod -f #{mongo_config_file}"
    end

    task :stop do
      raise "Host not local!" unless (template_data[:db_host] == 'localhost' || template_data[:db_host] == '127.0
.0.1')
      if File.exists? mongo_pid_file
        pid = File.read(mongo_pid_file)
        sh "kill #{pid}"
        sh "rm #{mongo_pid_file}"
      end
    end

    task :bootstrap do
      do_not_start_stop = false
      if template_data[:db_host] == 'localhost' || template_data[:db_host] == '127.0 .0.1'
        raise "Mongo is running" if File.exists? mongo_pid_file
      else
        do_not_stop_start = true
      end
      template = Erubis::Eruby.new(File.read(File.join(AresMUSH.game_path, 'db', 'bootstrap.js.erb')))
      template_data[:db_auth_enabled] = false
      Rake::Task['db:local:start'].execute unless do_not_start_stop
      Kernel.sleep 5.seconds unless do_not_start_stop
      script = Tempfile.new(['aresmush_bootstrap', '.js'])
      data = template.evaluate(template_data)
      File.open(script, 'w+') { |f| f.write(data) }
      cmd =<<-eos
      mongo #{template_data[:db_host]}:#{template_data[:db_port]} #{script.path}
      eos
      puts cmd
      sh cmd
      Rake::Task['db:local:stop'].execute unless do_not_start_stop
    end
  end
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
  
  AresMUSH::ServerInfo.create(
    game_id: AresMUSH::ServerInfo.arescentral_game_id,
    name: "AresCentral", 
    description: "Central hub for all things AresMUSH-related.", 
    host: "mush.aresmush.com",
    port: 7206)
    
  puts "Install complete."
end

task :upgrade do
  bootstrapper = AresMUSH::Bootstrapper.new
end

RSpec::Core::RakeTask.new do |t|
  t.pattern = FileList["./**/*_spec?.rb"]
end

task :default => :start

